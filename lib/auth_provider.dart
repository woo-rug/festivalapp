import 'package:flutter/material.dart';
import 'auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String? _accessToken;
  String? _refreshToken;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  bool get isLoggedIn => _accessToken != null;

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
      notifyListeners();
    }
    return result;
  }

  Future<void> logout(BuildContext context) async {
    await _authService.logout(context);
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }

  Future<String?> getValidAccessToken(BuildContext context) async {
    // 유효성 검사 (예: 401 처리 포함)
    final isValid = await _authService.validateToken(context);
    if (isValid) {
      _accessToken = await _authService.getAccessToken();
      notifyListeners();
      return _accessToken;
    } else {
      return null;
    }
  }
}
