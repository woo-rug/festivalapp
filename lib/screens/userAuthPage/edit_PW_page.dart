import 'dart:convert';
import 'package:festivalapp/screens/userAuthPage/edit_result_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:festivalapp/modules/base_layouts.dart';
import 'package:festivalapp/modules/button_modules.dart';
import 'package:flutter/material.dart';

class EditPWPage extends StatefulWidget {
  final String currentPassword;
  const EditPWPage({super.key, required this.currentPassword});

  @override
  State<EditPWPage> createState() => _EditPWPageState();
}

class _EditPWPageState extends State<EditPWPage> {
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _isMatch = true;
  bool _isSafe = false;
  bool _isSameAsOld = false;

  void validate() {
    final pw = _pwController.text;
    final confirm = _confirmController.text;
    setState(() {
      _isMatch = pw == confirm;
      _isSameAsOld = pw == widget.currentPassword;
      _isSafe = pw.isNotEmpty &&
          pw.length >= 8 &&
          RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(pw) &&
          !_isSameAsOld;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CurveScreen(
      title: const Column(
        children: [
          SizedBox(height:40),
          Text(
            "비밀번호 변경",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("비밀번호", style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _pwController,
              obscureText: _obscure1,
              onChanged: (_) => validate(),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(_obscure1 ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscure1 = !_obscure1),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _pwController.text.isEmpty
                  ? ''
                  : !_isSafe && _isSameAsOld
                    ? "❗ 이전과 다른 비밀번호를 입력해주세요."
                    : _isSafe
                      ? "✅ 안전한 비밀번호입니다."
                      : "❗ 비밀번호는 8자 이상이며 영문과 숫자를 포함해야 합니다.",
                style: TextStyle(
                  color: _isSafe ? Colors.green : Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("비밀번호 확인", style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _confirmController,
              obscureText: _obscure2,
              onChanged: (_) => validate(),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(_obscure2 ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscure2 = !_obscure2),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _confirmController.text.isEmpty || _isMatch
                  ? ""
                  : "❗ 비밀번호가 일치하지 않습니다.",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: GradientButton(
                    height: 60,
                    text: '이전으로', 
                    onPressed: () => Navigator.pop(context), 
                    isBlue: false
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GradientButton(
                    height: 60,
                    text: '비밀번호 변경', 
                    onPressed: _isSafe && _isMatch
                      ? () async {
                          final storage = FlutterSecureStorage();
                          final accessToken = await storage.read(key: 'accessToken');

                          final response = await http.put(
                            Uri.parse('http://182.222.119.214:8081/api/members/profile/update-password'),
                            headers: {
                              'Content-Type': 'application/json',
                              'Authorization': 'Bearer $accessToken',
                            },
                            body: jsonEncode({
                              'currentPassword': widget.currentPassword,
                              'newPassword': _pwController.text,
                            }),
                          );

                          print('응답 상태 코드: ${response.statusCode}');
                          print('응답 본문: ${response.body}');

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditResultPage(
                                success: response.statusCode == 200 || response.statusCode == 204,
                                type: '비밀번호',
                              ),
                            ),
                          );
                        }
                      : null,
                    isBlue: _isSafe && _isMatch ? true : false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
  
}