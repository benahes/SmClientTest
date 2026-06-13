import "dotenv/config";
import { z } from "zod";

const envSchema = z.object({
  NODE_ENV: z
    .enum(["development", "test", "production"])
    .default("development"),
  PORT: z.coerce.number().int().positive().default(8080),
  CORS_ORIGIN: z.string().default("*"),
  RATE_LIMIT_WINDOW_MS: z.coerce
    .number()
    .int()
    .positive()
    .default(15 * 60 * 1000),
  RATE_LIMIT_MAX: z.coerce.number().int().positive().default(300),
  FIREBASE_PROJECT_ID: z.string().optional().default(""),
  FIREBASE_CLIENT_EMAIL: z.string().optional().default(""),
  FIREBASE_PRIVATE_KEY: z.string().optional().default(""),
  ENABLE_AUTH_MOCK: z
    .string()
    .default("true")
    .transform((value) => value.toLowerCase() === "true"),
  USER_DATA_FILE: z.string().default("data/users.json"),
});

const parsed = envSchema.safeParse(process.env);

if (!parsed.success) {
  console.error("❌ Invalid environment configuration:");
  console.error(parsed.error.flatten().fieldErrors);
  process.exit(1);
}

const env = parsed.data;

if (env.NODE_ENV === "production" && env.ENABLE_AUTH_MOCK) {
  console.error("❌ ENABLE_AUTH_MOCK must be false in production.");
  process.exit(1);
}

if (env.NODE_ENV === "production" && env.CORS_ORIGIN.trim() === "*") {
  console.error("❌ CORS_ORIGIN cannot be * in production.");
  process.exit(1);
}

export { env };
