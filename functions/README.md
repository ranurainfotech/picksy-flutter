# Picksy Cloud Functions

## `notifyRoomMatch`

Firestore trigger on `rooms/{roomId}/matches/{movieId}`. When a match newly crosses the group like threshold, sends FCM to every room member with a registered device token in `pushTokens/{uid}`.

## Places API (restaurants via RapidAPI)

Restaurant search uses **[Google Map Places New V2 on RapidAPI](https://rapidapi.com/letscrape-6bRBa3QguO5/api/google-map-places-new-v2)** — no direct Google Cloud Places billing key required.

Callable functions in `asia-south1`:

- `geocodeLocation` — text area → lat/lng
- `searchRestaurants` — nearby restaurant deck
- `getPlaceDetails` — match detail screen

### Setup

1. Subscribe to the RapidAPI product (free tier available for testing).
2. Copy your **RapidAPI key** from the dashboard.
3. Store it as a Firebase secret:

```bash
firebase functions:secrets:set RAPIDAPI_KEY
```

4. Deploy:

```bash
cd functions
npm install
npm run build
cd ..
firebase deploy --only functions
```

The API key stays on the server only — the Flutter app still calls Cloud Functions.

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
