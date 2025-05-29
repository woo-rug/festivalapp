import 'package:festivalapp/modules/base_layouts.dart';
import 'package:festivalapp/modules/button_modules.dart';
import 'package:festivalapp/screens/userAuthPage/register_agree_page.dart';
import 'package:flutter/material.dart';
import '../../auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  String? _error;
  bool _obscurePassword = true;
  bool _keepLogin = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final success = await _authService.login(
      _usernameController.text,
      _passwordController.text,
      _keepLogin,
    );

    setState(() {
      _isLoading = false;
      _error = success ? null : "로그인 실패";
    });

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CurveScreen(
      title: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: const BoxDecoration(
              color: Colors.grey,
            ),
            child: const Center(
              child: Text("아이콘", style: TextStyle(color: Colors.black, fontSize: 12)),
            ),
          ),
          const SizedBox(height: 0),
          const Text(
            "로그인",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: '아이디',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: '비밀번호',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: _keepLogin,
                  onChanged: (value) {
                    setState(() {
                      _keepLogin = value!;
                    });
                  },
                ),
                const Text("로그인 유지하기"),
              ],
            ),
            const SizedBox(height: 16),
            GradientButton(
              onPressed: () {},
              isBlue: true,
              text: '로그인',
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 12),
            GradientButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (BuildContext context) => const RegisterAgreePage()
                  ),
                );
              },
              isBlue: false,
              text: '회원가입',
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/find');
              },
              child: const Text(
                '아이디/비밀번호 찾기',
                style: TextStyle(color: Color(0xFF1976D2), fontWeight: FontWeight.w500,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
