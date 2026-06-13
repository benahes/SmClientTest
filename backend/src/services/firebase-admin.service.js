import admin from 'firebase-admin';

import { env } from '../config/env.js';

let initialized = false;

function hasFirebaseCredentials() {
  return Boolean(env.FIREBASE_PROJECT_ID && env.FIREBASE_CLIENT_EMAIL && env.FIREBASE_PRIVATE_KEY);
}

function initializeFirebaseAdmin() {
  if (initialized) return;

  if (!hasFirebaseCredentials()) {
    throw new Error('Firebase Admin credentials are not configured.');
  }

  const privateKey = env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n');

  admin.initializeApp({
    credential: admin.credential.cert({
      projectId: env.FIREBASE_PROJECT_ID,
      clientEmail: env.FIREBASE_CLIENT_EMAIL,
      privateKey,
    }),
  });

  initialized = true;
}

function isFirebaseAdminConfigured() {
  return hasFirebaseCredentials();
}

function getFirebaseAuth() {
  initializeFirebaseAdmin();
  return admin.auth();
}

export { getFirebaseAuth, isFirebaseAdminConfigured };
