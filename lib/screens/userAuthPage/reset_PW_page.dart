import 'package:festivalapp/modules/base_layouts.dart';
import 'package:flutter/material.dart';

class ResetPWPage extends StatelessWidget{
  const ResetPWPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    final TextEditingController _pwController = TextEditingController();
    final TextEditingController _confirmController = TextEditingController();
    bool _obscure1 = true;
    bool _obscure2 = true;
    bool _isMatch = true;
    bool _isSafe = false;

    return StatefulBuilder(
      builder: (context, setState) {
        void validate() {
          final pw = _pwController.text;
          final confirm = _confirmController.text;
          setState(() {
            _isMatch = pw == confirm;
            _isSafe = pw.length >= 8 && RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(pw);
          });
        }

        return CurveScreen(
          title: Text("비밀번호 변경"),
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
                    _isSafe ? "✅ 안전한 비밀번호입니다." : "",
                    style: TextStyle(color: Colors.green, fontSize: 12),
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
                    _isMatch ? "" : "❗ 비밀번호가 일치하지 않습니다.",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.grey.shade300,
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("이전으로"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isMatch && _isSafe ? () {} : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF64B5F6),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("비밀번호 변경"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
  
}