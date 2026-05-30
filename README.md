# Picksy Flutter

Realtime group decision app — movies, restaurants, activities.

## Deferred until Apple Developer account

These need a **paid Apple Developer Program** membership:

| Feature | Android today | iOS |
|--------|----------------|-----|
| **Match push notifications** | Works (FCM + Cloud Function) | Blocked — requires APNs |
| **Universal Links** (`https://picksy.app/rooms/...`) | App Links intent filter | Blocked — requires Associated Domains |

Until then:

- **Invites:** share/copy the room link manually; Android users can open links in-app when App Links are verified on `picksy.app`.
- **Matches on iOS:** in-app match overlay still works; no push banner.
- **Cloud Function** `notifyRoomMatch` stays deployed — Android members get pushes when a match qualifies.

Re-enable iOS when you have an Apple account: set `PlatformCapabilities.iosUniversalLinksEnabled`, restore entitlements in `ios/Runner/Runner.entitlements`, and upload APNs key in Firebase Console.

## Match notifications (Android)

1. Deploy functions: `cd functions && npm run build && cd .. && firebase deploy --only functions`
2. Each Android user opens the app logged in and allows notifications.
3. Tokens land in Firestore `pushTokens/{uid}`.

Region: **Mumbai (`asia-south1`)** — must match Firestore.
