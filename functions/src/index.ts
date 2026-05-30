import { FieldValue } from "firebase-admin/firestore";
import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { getMessaging } from "firebase-admin/messaging";
import { onDocumentWritten } from "firebase-functions/v2/firestore";
import { logger } from "firebase-functions/v2";

import { matchJustCrossedThreshold } from "./matchThreshold";
import { FUNCTIONS_REGION } from "./region";

initializeApp();

const db = getFirestore();
const messaging = getMessaging();

const MATCHES_CHANNEL_ID = "picksy_matches";

type MatchDoc = {
  title?: string;
  likedBy?: string[];
};

function likedByCount(data: MatchDoc | undefined): number {
  if (!data?.likedBy || !Array.isArray(data.likedBy)) {
    return 0;
  }
  return data.likedBy.filter((id) => typeof id === "string").length;
}

function collectTokens(fcmTokens: unknown): string[] {
  if (!Array.isArray(fcmTokens)) {
    return [];
  }
  return fcmTokens.filter(
    (token): token is string => typeof token === "string" && token.length > 0,
  );
}

async function tokensForUser(uid: string): Promise<string[]> {
  const pushSnap = await db.collection("pushTokens").doc(uid).get();
  const pushTokens = collectTokens(pushSnap.data()?.tokens);
  if (pushTokens.length > 0) {
    return pushTokens;
  }

  const userSnap = await db.collection("users").doc(uid).get();
  return collectTokens(userSnap.data()?.fcmTokens);
}

async function removeInvalidTokens(
  uid: string,
  invalidTokens: string[],
): Promise<void> {
  if (invalidTokens.length === 0) {
    return;
  }

  const pushRef = db.collection("pushTokens").doc(uid);
  const pushSnap = await pushRef.get();
  if (pushSnap.exists) {
    await pushRef.update({
      tokens: FieldValue.arrayRemove(...invalidTokens),
    });
    return;
  }

  await db.collection("users").doc(uid).update({
    fcmTokens: FieldValue.arrayRemove(...invalidTokens),
  });
}

export const notifyRoomMatch = onDocumentWritten(
  {
    document: "rooms/{roomId}/matches/{movieId}",
    region: FUNCTIONS_REGION,
  },
  async (event) => {
    const afterSnap = event.data?.after;
    if (!afterSnap?.exists) {
      return;
    }

    const roomId = event.params.roomId;
    const movieId = event.params.movieId;
    const after = afterSnap.data() as MatchDoc;
    const before = event.data?.before?.exists
      ? (event.data.before.data() as MatchDoc)
      : undefined;

    const roomSnap = await db.collection("rooms").doc(roomId).get();
    if (!roomSnap.exists) {
      return;
    }

    const members = (roomSnap.data()?.members as string[] | undefined) ?? [];
    const memberCount = members.length;
    if (memberCount < 2) {
      return;
    }

    const beforeLikes = likedByCount(before);
    const afterLikes = likedByCount(after);
    if (!matchJustCrossedThreshold(beforeLikes, afterLikes, memberCount)) {
      return;
    }

    const title = (after.title as string | undefined)?.trim() || "a pick";
    const notificationTitle = "It's a match! 🍿";
    const notificationBody = `Your group matched on ${title}`;

    const tokenEntries: { uid: string; token: string }[] = [];
    for (const uid of members) {
      for (const token of await tokensForUser(uid)) {
        tokenEntries.push({ uid, token });
      }
    }

    if (tokenEntries.length === 0) {
      logger.info("No FCM tokens for room members", { roomId, movieId });
      return;
    }

    const tokens = tokenEntries.map((entry) => entry.token);
    const response = await messaging.sendEachForMulticast({
      tokens,
      notification: {
        title: notificationTitle,
        body: notificationBody,
      },
      data: {
        type: "match",
        roomId,
        movieId,
      },
      android: {
        priority: "high",
        notification: {
          channelId: MATCHES_CHANNEL_ID,
        },
      },
      apns: {
        payload: {
          aps: {
            sound: "default",
            badge: 1,
          },
        },
      },
    });

    const invalidByUid = new Map<string, Set<string>>();
    response.responses.forEach((sendResponse, index) => {
      if (sendResponse.success) {
        return;
      }
      const code = sendResponse.error?.code;
      if (
        code !== "messaging/invalid-registration-token" &&
        code !== "messaging/registration-token-not-registered"
      ) {
        logger.warn("FCM send failed", {
          roomId,
          movieId,
          code,
          message: sendResponse.error?.message,
        });
        return;
      }
      const { uid, token } = tokenEntries[index]!;
      const set = invalidByUid.get(uid) ?? new Set<string>();
      set.add(token);
      invalidByUid.set(uid, set);
    });

    await Promise.all(
      [...invalidByUid.entries()].map(([uid, invalidTokens]) =>
        removeInvalidTokens(uid, [...invalidTokens]),
      ),
    );

    logger.info("Match notifications sent", {
      roomId,
      movieId,
      successCount: response.successCount,
      failureCount: response.failureCount,
    });
  },
);
