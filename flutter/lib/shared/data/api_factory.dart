import 'api_client.dart';
import 'api_config.dart';

ApiClient buildApiClient() {
  return ApiClient(
    baseUrl: ApiConfig.baseUrl,
    bearerToken: ApiConfig.bearerToken,
  );
}
