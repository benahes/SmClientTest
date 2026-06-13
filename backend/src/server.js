import app from './app.js';
import { env } from './config/env.js';

const server = app.listen(env.PORT, '0.0.0.0', () => {
  console.log(`✅ Backend running on http://0.0.0.0:${env.PORT}`);
  console.log(`✅ Health check: http://127.0.0.1:${env.PORT}/health`);
  console.log(`✅ Ping: http://127.0.0.1:${env.PORT}/api/ping`);
});

function shutdown(signal) {
  console.log(`\n⚠️ Received ${signal}. Shutting down gracefully...`);
  server.close(() => {
    console.log('✅ HTTP server closed.');
    process.exit(0);
  });

  setTimeout(() => {
    console.error('❌ Force shutdown after timeout.');
    process.exit(1);
  }, 10_000).unref();
}

process.on('SIGINT', () => shutdown('SIGINT'));
process.on('SIGTERM', () => shutdown('SIGTERM'));

process.on('unhandledRejection', (reason) => {
  console.error('❌ Unhandled rejection:', reason);
});

process.on('uncaughtException', (error) => {
  console.error('❌ Uncaught exception:', error);
  process.exit(1);
});
