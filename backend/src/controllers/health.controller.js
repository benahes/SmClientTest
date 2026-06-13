import { env } from '../config/env.js';

function getHealth(_req, res) {
  return res.status(200).json({
    ok: true,
    service: 'smclient-backend',
    env: env.NODE_ENV,
    uptimeSeconds: Math.round(process.uptime()),
    timestamp: new Date().toISOString(),
  });
}

function getPing(_req, res) {
  return res.status(200).json({
    ok: true,
    message: 'pong',
    timestamp: new Date().toISOString(),
  });
}

export { getHealth, getPing };
