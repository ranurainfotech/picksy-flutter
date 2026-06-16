/**
 * Seeds Firestore app_config/monetization.
 *
 * From the functions/ directory:
 *   export GOOGLE_APPLICATION_CREDENTIALS="/path/to/serviceAccountKey.json"
 *   npm run seed:monetization
 *
 * Get a service account key: Firebase Console → Project settings → Service accounts
 * → Generate new private key
 */
const path = require('path');
const fs = require('fs');

// Resolve firebase-admin from functions/node_modules regardless of cwd.
const functionsDir = path.resolve(__dirname, '..');
const adminApp = require(path.join(functionsDir, 'node_modules/firebase-admin/app'));
const adminFirestore = require(path.join(functionsDir, 'node_modules/firebase-admin/firestore'));

const { initializeApp, applicationDefault, cert } = adminApp;
const { getFirestore } = adminFirestore;

const projectId = 'picksy-mobile-app';

function resolveCredential() {
  const keyPath =
    process.env.GOOGLE_APPLICATION_CREDENTIALS ||
    process.env.FIREBASE_SERVICE_ACCOUNT;

  if (keyPath) {
    const resolved = path.resolve(keyPath);
    if (!fs.existsSync(resolved)) {
      console.error(`Service account file not found: ${resolved}`);
      process.exit(1);
    }
    return cert(require(resolved));
  }

  return applicationDefault();
}

try {
  initializeApp({
    credential: resolveCredential(),
    projectId,
  });
} catch (error) {
  console.error('Failed to initialize Firebase Admin.\n');
  console.error(
    'Use the Firebase Console instead (easiest):\n' +
      '  https://console.firebase.google.com/project/picksy-mobile-app/firestore\n' +
      '  Collection: app_config  →  Document: monetization\n',
  );
  console.error(
    'Or download a service account key and run:\n' +
      '  cd functions\n' +
      '  export GOOGLE_APPLICATION_CREDENTIALS="/path/to/serviceAccountKey.json"\n' +
      '  npm run seed:monetization\n',
  );
  console.error(error.message);
  process.exit(1);
}

const doc = {
  monetizationEnabled: true,
  freeActiveRoomLimit: 2,
  freeDailySwipeLimit: 20,
};

getFirestore()
  .collection('app_config')
  .doc('monetization')
  .set(doc, { merge: true })
  .then(() => {
    console.log('Seeded app_config/monetization:', doc);
    process.exit(0);
  })
  .catch((error) => {
    console.error('Seed failed:', error.message);
    console.error(
      '\nTip: create the document manually in Firebase Console if you do not have a service account key.',
    );
    process.exit(1);
  });
