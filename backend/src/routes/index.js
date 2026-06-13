import { Router } from "express";

import { getPing } from "../controllers/health.controller.js";
import { authRouter } from "./auth.routes.js";
import { healthRouter } from "./health.routes.js";
import { usersRouter } from "./users.routes.js";

const apiRouter = Router();

apiRouter.use("/health", healthRouter);
apiRouter.get("/api/ping", getPing);
apiRouter.use("/auth", authRouter);
apiRouter.use("/users", usersRouter);

export { apiRouter };
