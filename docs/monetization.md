# Monetization

Picksy includes a **feature-flagged** hybrid monetization system. It is **off by default** until you enable it in Firestore.

## Firestore config

**You must create this document manually.** The `app_config` collection does not exist until you add it.

### Firebase Console

1. Open [Firestore](https://console.firebase.google.com/project/picksy-mobile-app/firestore) for `picksy-mobile-app`
2. Click **Start collection** (or **Add collection**)
3. Collection ID: `app_config`
4. Document ID: `monetization`
5. Add fields:

| Field | Type | Value |
| ----- | ---- | ----- |
| `monetizationEnabled` | boolean | `true` |
| `freeActiveRoomLimit` | number | `2` |
| `freeDailySwipeLimit` | number | `20` |

6. Save

Full path: `app_config/monetization`

```json
{
  "monetizationEnabled": true,
  "freeActiveRoomLimit": 2,
  "freeDailySwipeLimit": 20
}
```

Set `monetizationEnabled` to `false` to turn limits and ads off without redeploying the app.

### Optional: seed script (needs a service account key)

`gcloud` is **not** required. `firebase login` alone is not enough for this script.

1. [Firebase Console → Project settings → Service accounts](https://console.firebase.google.com/project/picksy-mobile-app/settings/serviceaccounts/adminsdk) → **Generate new private key**
2. Save the JSON file somewhere safe (do not commit it)
3. Run from the **`functions/`** directory:

```bash
cd functions
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/serviceAccountKey.json"
npm run seed:monetization
```

Do **not** prefix with `functions/` if you are already inside `functions/`.

## Free vs Pro

|                      | Free                      | Pro       |
| -------------------- | ------------------------- | --------- |
| Active rooms created | 2                         | Unlimited |
| Swipes per day       | 20                        | Unlimited |
| Ads                  | 3 milestone interstitials | None      |

### Ad triggers (free tier only)

1. After room created successfully
2. After the first match celebration is dismissed in a swipe session (Keep Swiping or Add to Watchlist) — one ad per swipe-screen visit, not per match
3. After room settings are saved

Match ads run **after** the celebration overlay fade-out completes, so animations are never interrupted. Leaving the swipe screen and returning starts a new session (the match ad can show again on the first dismiss of that visit).

## RevenueCat setup

1. Create a RevenueCat project and entitlement id `pro`
2. Add iOS/Android apps and products
3. Set in `.env`:
   - `REVENUECAT_IOS_API_KEY`
   - `REVENUECAT_ANDROID_API_KEY`

## AdMob setup

1. Create interstitial ad units in AdMob
2. Set in `.env` (or use Google test IDs in debug):
   - `ADMOB_IOS_INTERSTITIAL_ID`
   - `ADMOB_ANDROID_INTERSTITIAL_ID`
3. Replace test `APPLICATION_ID` in `AndroidManifest.xml` for production

## iOS

Add `GADApplicationIdentifier` to `Info.plist` and App Tracking Transparency usage description before enabling ads on iOS.
