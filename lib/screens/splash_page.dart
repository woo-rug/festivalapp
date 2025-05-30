import 'package:festivalapp/auth/auth_service.dart';
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
    await Future.delayed(const Duration(seconds: 2));
    // try {
    //   final authProvider = context.read<AuthProvider>();
    //   final shouldKeepLogin = await authProvider.shouldKeepLogin();

    //   if (shouldKeepLogin) {
    //     final refreshedToken = await authProvider.refreshToken(context);
    //     if (refreshedToken != null && mounted) {
    //       Navigator.pushReplacementNamed(context, '/home');
    //       return;
    //     }
    //   }

    //   if (mounted) {
    //     Navigator.pushReplacementNamed(context, '/login');
    //   }
    // } catch (e) {
    //   if (mounted) {
    //     Navigator.pushReplacementNamed(context, '/login');
    //   }
    // }

    // 일단 keepLogin 값만 확인 후 메인/로그인 확인하는 코드로 작성
    final authProvider = context.read<AuthProvider>();
    final shouldKeepLogin = await authProvider.shouldKeepLogin();

    if(shouldKeepLogin) { Navigator.pushReplacementNamed(context, '/main'); }
    else{ Navigator.pushReplacementNamed(context, '/login');}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(height: 35, width:35, decoration: BoxDecoration(color: Colors.grey),),
            SizedBox(height: 24),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
