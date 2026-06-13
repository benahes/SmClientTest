import { upsertUserFromAuth } from "../services/user-store.service.js";

async function firebaseAuthHandshake(req, res) {
  const user = await upsertUserFromAuth(req.user);

  return res.status(200).json({
    ok: true,
    message: "Authenticated",
    user: {
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
      provider: user.provider,
      mock: user.mock,
    },
    timestamp: new Date().toISOString(),
  });
}

export { firebaseAuthHandshake };
