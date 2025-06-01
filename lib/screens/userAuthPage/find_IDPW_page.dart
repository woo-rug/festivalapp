import 'package:festivalapp/modules/base_layouts.dart';
import 'package:flutter/material.dart';

class FindIDPWPage extends StatefulWidget {
  const FindIDPWPage({super.key});

  @override
  State<FindIDPWPage> createState() => _FindIDPWPageState();
}

class _FindIDPWPageState extends State<FindIDPWPage> {
  bool isFindID = true;

  final nameController = TextEditingController();
  final emailController = TextEditingController();

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildToggleButton('아이디 찾기', true),
                const SizedBox(width: 8),
                _buildToggleButton('비밀번호 찾기', false),
              ],
            ),
            const SizedBox(height: 32),
            _buildTextField(label: '이름', controller: nameController),
            const SizedBox(height: 16),
            _buildTextField(label: '이메일', controller: emailController),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF64B5F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // TODO: Add logic for finding ID or PW
                },
                child: Text(
                  isFindID ? '아이디 정보 찾기' : '비밀번호 정보 찾기',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool idButton) {
    final selected = isFindID == idButton;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isFindID = idButton),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF64B5F6) : const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
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
}