import { Router } from "express";

import { firebaseAuthHandshake } from "../controllers/auth.controller.js";
import { requireAuth } from "../middlewares/require-auth.js";
import { asyncHandler } from "../utils/async-handler.js";

const authRouter = Router();

authRouter.post("/firebase", requireAuth, asyncHandler(firebaseAuthHandshake));

export { authRouter };
