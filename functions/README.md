# Picksy Cloud Functions

## `notifyRoomMatch`

Firestore trigger on `rooms/{roomId}/matches/{movieId}`. When a match newly crosses the group like threshold, sends FCM to every room member with a registered device token in `pushTokens/{uid}`.

## Deploy

```bash
cd functions
npm install
npm run build
cd ..
firebase deploy --only functions
```

Requires Firebase Blaze for outbound FCM from Cloud Functions.

Functions deploy to **Mumbai (`asia-south1`)** — same region as Firestore.

**iOS pushes** are disabled in the app until APNs is configured (Apple Developer account). The function still sends to any iOS tokens if present; the client does not register them today.
