import 'package:festivalapp/modules/base_layouts.dart';
import 'package:festivalapp/screens/userAuthPage/edit_profile_page.dart';
import 'package:festivalapp/screens/userAuthPage/reset_PW_page.dart';
import 'package:flutter/material.dart';

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

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1)); // 비밀번호 확인 로직 대체용

    setState(() {
      _isLoading = false;
    });

    if (widget.actionType == 'editProfile') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfilePage()));
    } else if (widget.actionType == 'resetPassword') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ResetPWPage()));
    }
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
            ElevatedButton(
              onPressed: _isLoading ? null : _handleSubmit,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('확인'),
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