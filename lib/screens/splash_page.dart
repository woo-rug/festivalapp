import 'dart:async';

import 'package:festivalapp/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  late AnimationController _entranceController;
  late Animation<Offset> _entranceAnimation;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _entranceAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    ));

    _entranceController.forward();

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _currentIndex = 1;
      });
    });
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(milliseconds: 2200));
    final authProvider = context.read<AuthProvider>();
    final AuthService _authService = AuthService();
    final shouldKeepLogin = await authProvider.shouldKeepLogin();
    final accessToken = await _authService.getAccessToken();

    if (shouldKeepLogin && accessToken != null && accessToken.isNotEmpty) {
      await authProvider.refreshToken();
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: const AlwaysStoppedAnimation(1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/cullect_icon.png',
                height: 200,
                width: 200,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 30,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SlideTransition(
                      position: _entranceAnimation,
                      child: AnimatedOpacity(
                        opacity: _currentIndex == 0 ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: const Text(
                          '문화를 고르다,',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    AnimatedSlide(
                      offset: _currentIndex == 1 ? Offset(0, 0) : Offset(0, 1),
                      duration: const Duration(milliseconds: 500),
                      child: Opacity(
                        opacity: _currentIndex == 1 ? 1.0 : 0.0,
                        child: const Text(
                          '문화를 모으다.',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
