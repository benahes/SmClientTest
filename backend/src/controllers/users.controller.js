import { z } from 'zod';

import {
  getUserByUid,
  upsertUserFromAuth,
  updateUserByUid,
} from '../services/user-store.service.js';

const syncBodySchema = z
  .object({
    displayName: z.string().trim().max(120).optional(),
    photoUrl: z.string().trim().url().max(1000).optional(),
  })
  .default({});

const updateBodySchema = z
  .object({
    displayName: z.string().trim().max(120).nullable().optional(),
    photoUrl: z.string().trim().url().max(1000).nullable().optional(),
  })
  .refine((value) => Object.keys(value).length > 0, {
    message: 'At least one field is required.',
  });

function toSafeUser(user) {
  return {
    uid: user.uid,
    email: user.email,
    displayName: user.displayName,
    photoUrl: user.photoUrl,
    provider: user.provider,
    createdAt: user.createdAt,
    updatedAt: user.updatedAt,
    lastLoginAt: user.lastLoginAt,
    mock: user.mock,
  };
}

async function syncCurrentUser(req, res) {
  const body = syncBodySchema.parse(req.body ?? {});

  const user = await upsertUserFromAuth(req.user, {
    displayName: body.displayName,
    photoUrl: body.photoUrl,
  });

  return res.status(200).json({
    ok: true,
    user: toSafeUser(user),
  });
}

async function getCurrentUser(req, res) {
  const user = await getUserByUid(req.user.uid);
  if (!user) {
    return res.status(404).json({
      ok: false,
      message: 'User not found. Call /users/me/sync first.',
    });
  }

  return res.status(200).json({
    ok: true,
    user: toSafeUser(user),
  });
}

async function updateCurrentUser(req, res) {
  const body = updateBodySchema.parse(req.body ?? {});

  const updated = await updateUserByUid(req.user.uid, {
    displayName: body.displayName,
    photoUrl: body.photoUrl,
  });

  if (!updated) {
    return res.status(404).json({
      ok: false,
      message: 'User not found. Call /users/me/sync first.',
    });
  }

  return res.status(200).json({
    ok: true,
    user: toSafeUser(updated),
  });
}

export { getCurrentUser, syncCurrentUser, updateCurrentUser };
