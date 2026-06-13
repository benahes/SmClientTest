import { env } from "../config/env.js";
import {
  getFirebaseAuth,
  isFirebaseAdminConfigured,
} from "../services/firebase-admin.service.js";

async function requireAuth(req, res, next) {
  const authorization = req.headers.authorization ?? "";

  if (!authorization.startsWith("Bearer ")) {
    return res.status(401).json({
      ok: false,
      message: "Missing Bearer token.",
    });
  }

  const token = authorization.substring("Bearer ".length).trim();

  if (!token) {
    return res.status(401).json({
      ok: false,
      message: "Bearer token is empty.",
    });
  }

  if (env.ENABLE_AUTH_MOCK) {
    req.user = {
      uid: "local-dev-user",
      email: "dev@local.test",
      displayName: "Local Dev User",
      photoUrl: null,
      provider: "mock",
      token,
      mock: true,
    };
    return next();
  }

  if (!isFirebaseAdminConfigured()) {
    return res.status(500).json({
      ok: false,
      message: "Firebase Admin credentials are missing on server.",
    });
  }

  try {
    const auth = getFirebaseAuth();
    const decoded = await auth.verifyIdToken(token, true);

    req.user = {
      uid: decoded.uid,
      email: decoded.email ?? null,
      displayName: decoded.name ?? null,
      photoUrl: decoded.picture ?? null,
      provider: decoded.firebase?.sign_in_provider ?? null,
      decoded,
      mock: false,
    };

    return next();
  } catch (error) {
    return res.status(401).json({
      ok: false,
      message: "Invalid or expired Firebase token.",
    });
  }
}

export { requireAuth };
