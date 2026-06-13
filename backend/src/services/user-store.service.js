import { mkdir, readFile, rename, writeFile } from 'node:fs/promises';
import path from 'node:path';

import { env } from '../config/env.js';

const filePath = path.resolve(process.cwd(), env.USER_DATA_FILE);
const dirPath = path.dirname(filePath);

let loaded = false;
/** @type {Map<string, any>} */
const users = new Map();
let writeQueue = Promise.resolve();

async function ensureStoreReady() {
  await mkdir(dirPath, { recursive: true });

  try {
    const raw = await readFile(filePath, 'utf8');
    const parsed = JSON.parse(raw || '[]');
    if (Array.isArray(parsed)) {
      users.clear();
      for (const user of parsed) {
        if (user?.uid) users.set(user.uid, user);
      }
    }
  } catch (error) {
    if (error?.code === 'ENOENT') {
      await persist();
      return;
    }
    throw error;
  }
}

async function loadIfNeeded() {
  if (loaded) return;
  await ensureStoreReady();
  loaded = true;
}

async function persist() {
  const payload = JSON.stringify([...users.values()], null, 2);
  const tempPath = `${filePath}.tmp`;

  await writeFile(tempPath, payload, 'utf8');
  await rename(tempPath, filePath);
}

function queuePersist() {
  writeQueue = writeQueue.then(() => persist());
  return writeQueue;
}

function normalizeNullableString(value) {
  if (value == null) return null;
  const v = String(value).trim();
  return v.length ? v : null;
}

/**
 * @param {{ uid: string, email?: string|null, displayName?: string|null, photoUrl?: string|null, provider?: string|null, mock?: boolean }} authUser
 * @param {{ displayName?: string|null, photoUrl?: string|null }} [input]
 */
async function upsertUserFromAuth(authUser, input = {}) {
  await loadIfNeeded();

  const now = new Date().toISOString();
  const existing = users.get(authUser.uid);

  const record = {
    uid: authUser.uid,
    email: normalizeNullableString(authUser.email) ?? existing?.email ?? null,
    displayName:
      normalizeNullableString(input.displayName) ??
      normalizeNullableString(authUser.displayName) ??
      existing?.displayName ??
      null,
    photoUrl:
      normalizeNullableString(input.photoUrl) ??
      normalizeNullableString(authUser.photoUrl) ??
      existing?.photoUrl ??
      null,
    provider: normalizeNullableString(authUser.provider) ?? existing?.provider ?? null,
    mock: Boolean(authUser.mock),
    createdAt: existing?.createdAt ?? now,
    updatedAt: now,
    lastLoginAt: now,
  };

  users.set(record.uid, record);
  await queuePersist();
  return record;
}

async function getUserByUid(uid) {
  await loadIfNeeded();
  return users.get(uid) ?? null;
}

/**
 * @param {string} uid
 * @param {{ displayName?: string|null, photoUrl?: string|null }} patch
 */
async function updateUserByUid(uid, patch) {
  await loadIfNeeded();
  const existing = users.get(uid);
  if (!existing) return null;

  const now = new Date().toISOString();

  const updated = {
    ...existing,
    displayName:
      patch.displayName !== undefined
        ? normalizeNullableString(patch.displayName)
        : existing.displayName,
    photoUrl:
      patch.photoUrl !== undefined
        ? normalizeNullableString(patch.photoUrl)
        : existing.photoUrl,
    updatedAt: now,
  };

  users.set(uid, updated);
  await queuePersist();
  return updated;
}

export { getUserByUid, upsertUserFromAuth, updateUserByUid };
