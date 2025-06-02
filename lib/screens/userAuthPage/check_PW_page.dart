import 'package:festivalapp/auth/auth_http_client.dart';
import 'package:festivalapp/auth/auth_provider.dart';
import 'package:festivalapp/auth/secure_storage_service.dart';
import 'package:festivalapp/modules/base_layouts.dart';
import 'package:festivalapp/modules/button_modules.dart';
import 'package:festivalapp/screens/userAuthPage/edit_profile_page.dart';
import 'package:festivalapp/screens/userAuthPage/reset_PW_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CheckPWPage extends StatefulWidget {
  final String actionType; // 'editProfile' or 'resetPassword'

  const CheckPWPage({Key? key, required this.actionType}) : super(key: key);

  @override
  _CheckPWPageState createState() => _CheckPWPageState();
}

class _CheckPWPageState extends State<CheckPWPage> {
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<bool> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return false;

    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final client = AuthHttpClient(authProvider, context);
    final _storage = SecureStorageService();
    final accessToken = await _storage.readToken('accessToken');

    final response = await client.post(
      Uri.parse('http://182.222.119.214:8081/api/members/profile/verify'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: '{"password": "${_passwordController.text}"}',
    );
    print(accessToken);
    print(_passwordController.text);
    print(response.body);

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      if (widget.actionType == 'editProfile') {
        return true;
      } else if (widget.actionType == 'resetPassword') {
        return true;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
      );
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return CurveScreen(
      title: const Column(
        children: [
          SizedBox(height:40),
          Text(
            "비밀번호 확인",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            const Text(
              '비밀번호를 입력해주세요',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해주세요';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 24),
            GradientButton(
              onPressed: () async {
                final success = await _handleSubmit();
                if (success) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => widget.actionType == 'editProfile'
                          ? const EditProfilePage()
                          : const ResetPWPage(),
                    ),
                  );
                }
              },
              text: '확인', isBlue: true,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('뒤로 가기'),
            ),
          ],
        ),
      ),
    );
  }
}