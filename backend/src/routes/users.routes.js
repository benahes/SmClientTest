import { Router } from 'express';

import {
  getCurrentUser,
  syncCurrentUser,
  updateCurrentUser,
} from '../controllers/users.controller.js';
import { requireAuth } from '../middlewares/require-auth.js';
import { asyncHandler } from '../utils/async-handler.js';

const usersRouter = Router();

usersRouter.use(requireAuth);
usersRouter.post('/me/sync', asyncHandler(syncCurrentUser));
usersRouter.get('/me', asyncHandler(getCurrentUser));
usersRouter.patch('/me', asyncHandler(updateCurrentUser));

export { usersRouter };
