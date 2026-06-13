class AppConfig {
  const AppConfig._();

  /// Pass this at build/run time when your Railway API is ready:
  ///
  /// flutter run --dart-define=RAILWAY_API_BASE_URL=https://your-api.up.railway.app
  static const railwayApiBaseUrl = String.fromEnvironment(
    'RAILWAY_API_BASE_URL',
    defaultValue: '',
  );

  static bool get hasRailwayApiBaseUrl => railwayApiBaseUrl.trim().isNotEmpty;
}
