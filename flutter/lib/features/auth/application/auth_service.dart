import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cicwtch/features/auth/data/auth_repository.dart';
import 'package:cicwtch/features/auth/domain/auth_user.dart';
import 'package:cicwtch/shared/data/api_config.dart';

const _kTokenKey = 'auth_session_token';

class AuthService extends ChangeNotifier {
  AuthService(this._repository);

  final AuthRepository _repository;

  AuthUser? _user;
  bool _isLoading = true;
  String? _error;

  AuthUser? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> restoreSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_kTokenKey);

      if (token != null && token.isNotEmpty) {
        ApiConfig.setSessionToken(token);
        final user = await _repository.getMe();
        if (user != null) {
          _user = user;
        } else {
          // Token invalid or expired — clear it
          await prefs.remove(_kTokenKey);
          ApiConfig.setSessionToken(null);
        }
      }
    } catch (_) {
      // Ignore restore failures; user will be asked to log in
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login({required String email, required String password}) async {
    _error = null;
    notifyListeners();

    final result = await _repository.login(email: email, password: password);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTokenKey, result.token);
    ApiConfig.setSessionToken(result.token);

    _user = result.user;
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
    } catch (_) {
      // Best-effort server-side logout; proceed with local cleanup regardless
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kTokenKey);
    ApiConfig.setSessionToken(null);

    _user = null;
    notifyListeners();
  }
}
