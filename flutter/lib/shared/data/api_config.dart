class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://cicwtch-api.nathcymru.workers.dev',
  );

  static const String _envBearerToken = String.fromEnvironment(
    'API_BEARER_TOKEN',
    defaultValue: '',
  );

  // Runtime session token — set by AuthService after login, cleared on logout.
  static String? _sessionToken;

  static String get bearerToken => _sessionToken ?? _envBearerToken;

  static void setSessionToken(String? token) {
    _sessionToken = token;
  }
}
