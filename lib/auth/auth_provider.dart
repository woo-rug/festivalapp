import 'package:flutter/material.dart';
import 'auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  String? _accessToken;
  String? _refreshToken;
  bool _keepLogin = false;

  bool get keepLogin => keepLogin;
  String? get accessToken => _accessToken;

  Future<void> loadTokensFromStorage() async {
    _accessToken = await _authService.getAccessToken();
    _refreshToken = await _authService.getRefreshToken();
    notifyListeners();
  }

  Future<bool> login(String username, String password, bool keepLogin) async {
    final result = await _authService.login(username, password, keepLogin);
    if (result) {
      _accessToken = await _authService.getAccessToken();
      _refreshToken = await _authService.getRefreshToken();
      _keepLogin = await _authService.shouldKeepLogin();
      notifyListeners();
    }
    return result;
  }

  Future<void> logout(BuildContext context) async {
    await _authService.logout(context);
    _accessToken = null;
    _refreshToken = null;
    _keepLogin = false;
    notifyListeners();
  }

  Future<bool> shouldKeepLogin() async {
    return await _authService.shouldKeepLogin();
  }

  Future<String?> getValidAccessToken(BuildContext context) async {
    final isValid = await _authService.validateToken(context);
    if (isValid) {
      _accessToken = await _authService.getAccessToken();
      notifyListeners();
      return _accessToken;
    }
    return null;
  }

  Future<String?> refreshToken(BuildContext context) async {
    final newToken = await _authService.refreshToken(context);
    if (newToken != null) {
      _accessToken = newToken;
      notifyListeners();
    }
    return newToken;
  }
}
