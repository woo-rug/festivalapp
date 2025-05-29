import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'secure_storage_service.dart';

class AuthService {
  final _storage = SecureStorageService();
  final _baseUrl = 'http://182.222.119.214:8081';

  // 로그인
  Future<bool> login(String username, String password, bool keepLogin) async {
    //서버 로그인 과정
    final response = await http.post(
      Uri.parse('$_baseUrl/api/members/sign-in'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    // 예시 과정
    // final response = (username == 'admin' && password == 'admin123');
    // if (response) {
    //   // 로그인 성공
    //   await _storage.saveToken('accessToken', 'accessToken123');
    //   await _storage.saveToken('refreshToken', 'refreshToken123');
    //   await _storage.saveToken('keepLogin', keepLogin.toString());
    //   return true;
    // } else {
    //   return false;
    // }

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      await _storage.saveToken('accessToken', body['accessToken']);
      await _storage.saveToken('refreshToken', body['refreshToken']);
      await _storage.saveToken('keepLogin', keepLogin.toString());
      return true;
    } else {
      return false;
    }
  }

  // accessToken 유효성 확인 → 만료되면 자동 재발급
  Future<bool> validateToken(BuildContext context) async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return false;

    final response = await http.get(
      Uri.parse('$_baseUrl/api/members/validate'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      return await tryReissueToken(context);
    }

    return false;
  }

  // accessToken + refreshToken 사용해 재발급
  Future<bool> tryReissueToken(BuildContext context) async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();

    if (accessToken == null || refreshToken == null) {
      await logout(context);
      return false;
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/api/members/reissue'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      await _storage.saveToken('accessToken', body['accessToken']);
      if (body['refreshToken'] != null) {
        await _storage.saveToken('refreshToken', body['refreshToken']);
      }
      return true;
    }

    await logout(context);
    return false;
  }

  // 로그아웃
  Future<void> logout(BuildContext context) async {
    await _storage.deleteAll();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  // 저장된 토큰 가져오기
  Future<String?> getAccessToken() async => await _storage.readToken('accessToken');
  Future<String?> getRefreshToken() async => await _storage.readToken('refreshToken');
  Future<bool> shouldKeepLogin() async => (await _storage.readToken('keepLogin')) == 'true';
}
