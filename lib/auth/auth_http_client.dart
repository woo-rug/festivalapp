import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'auth_provider.dart';
import '../screens/userAuthPage/login_page.dart';

class AuthHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();
  final AuthProvider authProvider;
  final BuildContext context;

  AuthHttpClient(this.authProvider, this.context);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = authProvider.accessToken;
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    var response = await _inner.send(request);

    if (response.statusCode == 403 &&
        !request.url.path.contains('/api/members/reissue')) {
      final newToken = await authProvider.refreshToken();
      if (newToken != null) {
        request.headers['Authorization'] = 'Bearer $newToken';
        response = await _inner.send(request);
      } else {
        await authProvider.logout();
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (_) => false,
          );
        }
      }
    }

    return response;
  }
}
