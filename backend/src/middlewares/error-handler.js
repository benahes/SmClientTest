import { env } from "../config/env.js";

function errorHandler(err, _req, res, _next) {
  const isZodError = err?.name === "ZodError";
  const statusCode = Number(
    err?.statusCode ?? err?.status ?? (isZodError ? 400 : 500),
  );
  const isServerError = statusCode >= 500;

  const message =
    !isServerError || env.NODE_ENV !== "production"
      ? err?.message || "Unexpected error."
      : "Internal server error.";

  if (env.NODE_ENV !== "production") {
    console.error("❌ Request error:", err);
  }

  return res.status(statusCode).json({
    ok: false,
    message,
    ...(isZodError && Array.isArray(err?.issues)
      ? {
          validation: err.issues.map((issue) => ({
            path: issue.path,
            message: issue.message,
          })),
        }
      : {}),
    ...(env.NODE_ENV !== "production" && err?.stack
      ? { stack: err.stack }
      : {}),
  });
}

export { errorHandler };
