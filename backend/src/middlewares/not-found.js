function notFoundHandler(req, res) {
  return res.status(404).json({
    ok: false,
    message: `Route not found: ${req.method} ${req.originalUrl}`,
  });
}

export { notFoundHandler };
