import 'package:cicwtch/features/auth/domain/auth_user.dart';
import 'package:cicwtch/shared/data/api_client.dart';

class AuthRepository {
  AuthRepository(this._api);

  final ApiClient _api;

  Future<({String token, String expiresAt, AuthUser user})> login({
    required String email,
    required String password,
  }) async {
    final json = await _api.post('/api/v1/auth/login', {
          'email': email,
          'password': password,
        }) as Map<String, dynamic>;

    final token = json['token'] as String;
    final expiresAt = json['expires_at'] as String;
    final user = AuthUser.fromJson(json['user'] as Map<String, dynamic>);

    return (token: token, expiresAt: expiresAt, user: user);
  }

  Future<void> logout() async {
    await _api.post('/api/v1/auth/logout', {});
  }

  Future<AuthUser?> getMe() async {
    try {
      final json = await _api.get('/api/v1/auth/me') as Map<String, dynamic>;
      return AuthUser.fromJson(json['user'] as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
