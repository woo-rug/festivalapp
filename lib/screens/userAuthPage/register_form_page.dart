import 'package:festivalapp/modules/postcode_page.dart';
import 'package:flutter/material.dart';
import '../../modules/base_layouts.dart';
import '../../modules/button_modules.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterFormPage extends StatefulWidget {
  const RegisterFormPage({super.key});

  @override
  State<RegisterFormPage> createState() => _RegisterFormPageState();
}

class _RegisterFormPageState extends State<RegisterFormPage> {
  bool isFormFilled = false;

  void updateFormFilled(bool filled) {
    setState(() {
      isFormFilled = filled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlatScreen(
      appBar: const Text(
        "회원가입",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          SignUpFormContent(onFormValidChange: updateFormFilled),
          const SizedBox(height: 100),
        ],
      ),
      floatingActionButton: FloatingButton(
        text: "다음 페이지로",
        onPressed: isFormFilled
            ? () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterFormPage()));
              }
            : null,
        isBlue: isFormFilled,
      ),
    );
  }
}

class CommonTextField extends StatefulWidget {
  final String? label;
  final bool isPassword;
  final TextEditingController controller;
  final String? hintText;
  final bool readOnly;
  final Function(String)? onChanged;

  const CommonTextField({
    super.key,
    this.label,
    this.isPassword = false,
    required this.controller,
    this.hintText,
    this.readOnly = false,
    this.onChanged,
  });

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  bool _obscure = false;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.label!,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        TextField(
          controller: widget.controller,
          readOnly: widget.readOnly,
          obscureText: _obscure,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          ),
        ),
      ],
    );
  }
}

class SignUpFormContent extends StatefulWidget {
  final Function(bool) onFormValidChange;
  const SignUpFormContent({super.key, required this.onFormValidChange});

  @override
  State<SignUpFormContent> createState() => _SignUpFormContentState();
}

class _SignUpFormContentState extends State<SignUpFormContent> {
  final idController = TextEditingController();
  final pwController = TextEditingController();
  final pwConfirmController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final emailCodeController = TextEditingController();
  final nicknameController = TextEditingController();
  final locationController = TextEditingController();
  final genderList = ['남성', '여성', '선택안함'];

  String selectedGender = '선택안함';
  bool? isPasswordMatch;
  bool isPasswordSafe = false;
  bool isIdAvailable = false;

  @override
  void initState() {
    super.initState();
    pwController.addListener(_checkPasswordMatch);
    pwConfirmController.addListener(_checkPasswordMatch);
  }

  void _checkPasswordMatch() {
    final pw = pwController.text;
    final confirm = pwConfirmController.text;
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}\$');

    setState(() {
      isPasswordMatch = (pw.isNotEmpty && confirm.isNotEmpty) ? pw == confirm : null;
      isPasswordSafe = regex.hasMatch(pw);
      _checkAllFilled();
    });
  }

  void _checkAllFilled() {
    bool filled =
        idController.text.isNotEmpty &&
        isIdAvailable &&
        pwController.text.isNotEmpty &&
        isPasswordSafe &&
        pwConfirmController.text.isNotEmpty &&
        isPasswordMatch == true &&
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        emailCodeController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        nicknameController.text.isNotEmpty;

    widget.onFormValidChange(filled);
  }

  Future<void> _checkIdDuplicate() async {
    final response = await http.get(Uri.parse('https://your.api/check-id?id=${idController.text}'));
    if (response.statusCode == 200 && jsonDecode(response.body)['available'] == true) {
      setState(() {
        isIdAvailable = true;
      });
    } else {
      setState(() {
        isIdAvailable = false;
      });
    }
    _checkAllFilled();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("정보 입력", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: CommonTextField(
                  label: "아이디",
                  controller: idController,
                  hintText: "아이디 입력",
                  onChanged: (_) => setState(() => isIdAvailable = false),
                ),
              ),
              const SizedBox(width: 8),
              GradientButton(text: '중복확인', onPressed: _checkIdDuplicate, isBlue: true, width: 150),
            ],
          ),
          if (isIdAvailable)
            const Text("✔ 사용 가능한 아이디입니다.", style: TextStyle(color: Colors.green, fontSize: 13)),

          const SizedBox(height: 16),

          CommonTextField(label: "비밀번호", controller: pwController, hintText: "비밀번호", isPassword: true),
          const SizedBox(height: 8),
          Text(
            isPasswordSafe ? "✅ 안전한 비밀번호입니다." : "❌ 최소 8자, 영문+숫자 조합이 필요합니다.",
            style: TextStyle(color: isPasswordSafe ? Colors.green : Colors.red, fontSize: 13),
          ),
          const SizedBox(height: 8),
          CommonTextField(label: "비밀번호 확인", controller: pwConfirmController, isPassword: true),
          if (isPasswordMatch != null)
            Text(
              isPasswordMatch == true ? "비밀번호가 일치합니다." : "비밀번호가 일치하지 않습니다.",
              style: TextStyle(color: isPasswordMatch == true ? Colors.green : Colors.red, fontSize: 13),
            ),

          const SizedBox(height: 16),
          CommonTextField(label: "이름", controller: nameController, onChanged: (_) => _checkAllFilled()),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: CommonTextField(label: "이메일", controller: emailController, hintText: "이메일 입력", onChanged: (_) => _checkAllFilled()),
              ),
              const SizedBox(width: 8),
              GradientButton(text: '이메일 보내기', onPressed: () {}, isBlue: true, width: 180),
            ],
          ),
          const SizedBox(height: 8),
          CommonTextField(label: "인증번호", controller: emailCodeController, onChanged: (_) => _checkAllFilled()),

          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: CommonTextField(label: "주소", controller: locationController, readOnly: true),
              ),
              const SizedBox(width: 8),
              GradientButton(
                text: '주소 검색',
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostcodePage(
                        onAddressSelected: (String selected) {
                          setState(() {
                            locationController.text = selected;
                          });
                          _checkAllFilled();
                        },
                      ),
                    ),
                  );
                },
                isBlue: true,
                width: 150,
              ),
            ],
          ),

          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: CommonTextField(label: "닉네임", controller: nicknameController, onChanged: (_) => _checkAllFilled()),
              ),
              const SizedBox(width: 8),
              GradientButton(text: '중복확인', onPressed: () {}, isBlue: true, width: 150),
            ],
          ),

          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedGender,
            decoration: const InputDecoration(
              labelText: "성별",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            ),
            items: genderList.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
            onChanged: (value) => setState(() => selectedGender = value!),
          ),
        ],
      ),
    );
  }
}
