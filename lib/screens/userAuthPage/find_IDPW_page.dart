import 'package:festivalapp/modules/base_layouts.dart';
import 'package:festivalapp/modules/button_modules.dart';
import 'package:festivalapp/screens/userAuthPage/find_IDPW_result_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FindIDPWPage extends StatefulWidget {
  const FindIDPWPage({super.key});

  @override
  State<FindIDPWPage> createState() => _FindIDPWPageState();
}

class _FindIDPWPageState extends State<FindIDPWPage> {
  late PageController _pageController;
  int _currentPage = 0;

  final idController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final ValueNotifier<bool> _formValidNotifier = ValueNotifier(false);

  void _updateFormValid() => _formValidNotifier.value = _isFormValid();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    idController.addListener(_updateFormValid);
    nameController.addListener(_updateFormValid);
    emailController.addListener(_updateFormValid);
  }

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    emailController.dispose();
    _formValidNotifier.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _check() async {
    final url = _currentPage == 0
        ? Uri.parse('http://182.222.119.214:8081/api/members/find-username')
        : Uri.parse('http://182.222.119.214:8081/api/members/find-password/temp');

    final body = _currentPage == 0
        ? {
            'name': nameController.text.trim(),
            'email': emailController.text.trim(),
          }
        : {
            'username': idController.text.trim(),
            'name': nameController.text.trim(),
            'email': emailController.text.trim(),
          };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': response.body};
      } else {
        final decoded = jsonDecode(response.body);
        return {'success': false, 'message': decoded['message'] ?? '알 수 없는 오류'};
      }
    } catch (e) {
      return {'success': false, 'message': '서버 오류: $e'};
    }
  }

  bool _isFormValid() {
    if (_currentPage == 0) {
      return nameController.text.trim().isNotEmpty &&
             emailController.text.trim().isNotEmpty;
    } else {
      return idController.text.trim().isNotEmpty &&
             nameController.text.trim().isNotEmpty &&
             emailController.text.trim().isNotEmpty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CurveScreen(
      title: const Column(
        children: [
          SizedBox(height:40),
          Text(
            "회원 정보 찾기",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  _buildToggleButton('아이디 찾기', 0),
                  _buildToggleButton('비밀번호 찾기', 1),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  SingleChildScrollView(child: _buildIDForm()),
                  SingleChildScrollView(child: _buildPWForm()),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: GradientButton(
        text: _currentPage == 0 ? '아이디 정보 찾기' : '비밀번호 초기화',
        onPressed: () async {
          final result = await _check();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FindIDPWResultPage(
                isID: _currentPage == 0,
                message: result['message'],
              ),
            ),
          );
        },
        isBlue: true,
        height: 60,
        width: 320,
      ),
    );
  }

  Widget _buildToggleButton(String text, int index) {
    final selected = _currentPage == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentPage = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: selected
                ? const LinearGradient(
                    colors: [Color(0xFF64B5F6), Color(0xFF1976D2)],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  )
                : null,
            color: selected ? null : const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildIDForm() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(label: '이름', controller: nameController),
        const SizedBox(height: 16),
        _buildTextField(label: '이메일', controller: emailController),
      ],
    ),
    );
  }

  Widget _buildPWForm() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(label: '아이디', controller: idController),
        const SizedBox(height: 16),
        _buildTextField(label: '이름', controller: nameController),
        const SizedBox(height: 16),
        _buildTextField(label: '이메일', controller: emailController),
        const SizedBox(height: 200,)
      ],
    ),
    );
  }
}