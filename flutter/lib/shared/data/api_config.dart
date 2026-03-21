class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://cicwtch-api.nathcymru.workers.dev',
  );

  static const String _compiledBearerToken = String.fromEnvironment(
    'API_BEARER_TOKEN',
    defaultValue: '',
  );

  // Runtime session token — set by AuthService after login, cleared on logout.
  static String? _sessionToken;

  static String get bearerToken => _sessionToken ?? _compiledBearerToken;

  static void setSessionToken(String? token) {
    _sessionToken = token;
  }
}
