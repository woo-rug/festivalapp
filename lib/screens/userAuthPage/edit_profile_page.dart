import 'dart:convert';
import 'package:festivalapp/screens/userAuthPage/register_form_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:festivalapp/modules/base_layouts.dart';
import 'package:festivalapp/modules/button_modules.dart';
import 'package:festivalapp/modules/postcode_page.dart';
import 'package:festivalapp/modules/title_modules.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final idController = TextEditingController(text: "exampleId");
  final nameController = TextEditingController(text: "홍길동");
  final emailController = TextEditingController(text: "email@example.com");
  final nicknameController = TextEditingController();
  final ageController = TextEditingController();
  final locationController = TextEditingController();
  String? selectedGender = '선택하세요';

  final genderList = ['선택하세요', '남성', '여성'];

  bool isFormValid = false;
  bool isNicknameChecked = false;
  String? nicknameCheckResult;

  void _checkFormValid() {
    setState(() {
      isFormValid = nicknameController.text.isNotEmpty &&
                    ageController.text.isNotEmpty &&
                    locationController.text.isNotEmpty &&
                    selectedGender != null &&
                    selectedGender != '선택하세요' &&
                    isNicknameChecked;
    });
  }

  bool isAgeValid = true;

  void _validateAge(String value) {
    final age = int.tryParse(value);
    final valid = age != null && age >= 1 && age <= 120;
    if (isAgeValid != valid) {
      setState(() {
        isAgeValid = valid;
      });
    }
    _checkFormValid();
  }

  void _checkNicknameDuplicate() async {
    // 서버 중복 확인 로직 예시 (추후 실제 API 연동)
    final nickname = nicknameController.text.trim();
    if (nickname == "takenNickname") {
      setState(() {
        isNicknameChecked = false;
        nicknameCheckResult = "❌ 이미 사용 중인 닉네임입니다.";
      });
    } else {
      setState(() {
        isNicknameChecked = true;
        nicknameCheckResult = "✅ 사용 가능한 닉네임입니다.";
      });
    }
    _checkFormValid();
  }

  @override
  void initState() {
    super.initState();
    nicknameController.addListener(() {
      setState(() {
        isNicknameChecked = false;
      });
      _checkFormValid();
    });
    ageController.addListener(() {
      _validateAge(ageController.text);
    });
    locationController.addListener(_checkFormValid);
  }

  @override
  Widget build(BuildContext context) {
    return FlatScreen(
      appBar: const Text(
        "프로필 수정",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 16),
          TitleModules.title("회원 정보 수정"),
          const SizedBox(height: 16),

          _buildReadOnlyField("아이디", idController),
          const SizedBox(height: 4),
          const Text("수정할 수 없는 항목입니다.", style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 16),
          _buildReadOnlyField("이름", nameController),
          const SizedBox(height: 4),
          const Text("수정할 수 없는 항목입니다.", style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 16),
          _buildReadOnlyField("이메일", emailController),
          const SizedBox(height: 4),
          const Text("수정할 수 없는 항목입니다.", style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: CommonTextField(
                  label: "닉네임",
                  controller: nicknameController,
                  onChanged: (_) => _checkFormValid(),
                ),
              ),
              const SizedBox(width: 8),
              GradientButton(
                text: '중복확인',
                onPressed: _checkNicknameDuplicate,
                isBlue: true,
                width: 150,
              ),
            ],
          ),
          if (nicknameCheckResult != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                nicknameCheckResult!,
                style: TextStyle(
                  color: nicknameCheckResult!.startsWith("✅") ? Colors.green : Colors.red,
                  fontSize: 13,
                ),
              ),
            ),
          const SizedBox(height: 16),
          _buildEditableField("나이", ageController),
          if (!isAgeValid)
            const Text("❌ 올바른 나이값을 입력하세요.", style: TextStyle(color: Colors.red, fontSize: 13)),
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
                  final selectedAddress = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostcodePage(),
                    ),
                  );

                  if (selectedAddress != null) {
                    setState(() {
                      locationController.text = selectedAddress.roadAddress;
                    });
                    _checkFormValid();
                  }
                },
                isBlue: true,
                width: 150,
              ),
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
            items: genderList.map((g) {
              return DropdownMenuItem<String>(
                value: g,
                child: Text(g),
                enabled: g != '선택하세요',
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedGender = value;
              });
              _checkFormValid();
            },
          ),
          const SizedBox(height: 100),
        ],
      ),
      floatingActionButton: FloatingButton(
        text: "수정 완료",
        onPressed: isFormValid
            ? () {
                // 서버 수정 요청 로직 추가
                Navigator.pop(context);
              }
            : null,
        isBlue: isFormValid,
      ),
    );
  }

  Widget _buildReadOnlyField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return CommonTextField(
      label: label,
      controller: controller,
      onChanged: (_) => _checkFormValid(),
    );
  }
}