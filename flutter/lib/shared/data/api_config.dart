class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://cicwtch-api.nathcymru.workers.dev',
  );
}
