# SmClient Backend (Node + Express)

A production-leaning backend scaffold for local development and Railway deployment.

## Features

- Secure defaults (`helmet`, `hpp`, `compression`)
- Configurable CORS policy
- Rate limiting
- Centralized error handling
- Firebase ID token verification middleware
- Optional mock auth mode for local early-stage development
- Railway-ready (`PORT` support + `railway.json`)

## Quick start

```bash
cd backend
cp .env.example .env
npm install
npm run dev
```

Server runs on `http://127.0.0.1:8080` by default.

## Run app against local backend (USB device)

From project root (`SmClient`):

```bash
adb reverse tcp:8080 tcp:8080
flutter run -d 1011325365111674 --dart-define=RAILWAY_API_BASE_URL=http://127.0.0.1:8080
```

## Routes

- `GET /health` - health/uptime
- `GET /api/ping` - quick test endpoint
- `POST /auth/firebase` - verifies Firebase bearer token + upserts user
- `POST /users/me/sync` - upsert current user profile
- `GET /users/me` - fetch current user profile
- `PATCH /users/me` - update display name/photo URL

## Auth behavior

`POST /auth/firebase` expects:

```http
Authorization: Bearer <firebase-id-token>
```

Response:

```json
{
  "ok": true,
  "message": "Authenticated",
  "user": {
    "uid": "...",
    "email": "..."
  }
}
```

### Local mock mode

Set in `.env`:

```env
ENABLE_AUTH_MOCK=true
```

In this mode, any bearer token is accepted for local testing.

### Production mode

Set:

```env
ENABLE_AUTH_MOCK=false
```

and provide Firebase Admin credentials via environment variables:

- `FIREBASE_PROJECT_ID`
- `FIREBASE_CLIENT_EMAIL`
- `FIREBASE_PRIVATE_KEY`

On Railway, put these in service Variables.

## Deploy to Railway

1. Push repo to GitHub.
2. Create Railway project from repo.
3. Set root directory to `backend` (if needed).
4. Add required env vars from `.env.example`.
5. Deploy.

## Recommended next steps

- Add your domain modules under `src/modules/...`
- Swap file storage for a database client (Prisma/Drizzle/Postgres)
- Add migration scripts for user/bookings tables
- Replace mock routes with real feature routes
- Add request validation per route
