import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final authProvider = context.read<AuthProvider>();
    final shouldKeepLogin = await authProvider.shouldKeepLogin();

    if (shouldKeepLogin) {
      final token = await authProvider.getValidAccessToken(context);
      if (token != null && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
        return;
      }
    }

    // 로그인 유지가 false거나, 토큰이 없거나, 재발급 실패
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
