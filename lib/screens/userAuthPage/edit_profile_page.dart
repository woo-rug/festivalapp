import 'dart:convert';
import 'package:festivalapp/screens/userAuthPage/edit_result_page.dart';
import 'package:festivalapp/screens/userAuthPage/register_form_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:festivalapp/modules/base_layouts.dart';
import 'package:festivalapp/modules/button_modules.dart';
import 'package:festivalapp/modules/postcode_page.dart';
import 'package:festivalapp/modules/title_modules.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  String? originalNickname;

  void _checkFormValid() {
    setState(() {
      isFormValid = nicknameController.text.isNotEmpty &&
                    ageController.text.isNotEmpty &&
                    locationController.text.isNotEmpty &&
                    selectedGender != null &&
                    selectedGender != '선택하세요' &&
                    (nicknameController.text.trim() == originalNickname || isNicknameChecked);
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
    final nickname = nicknameController.text.trim();
    if (nickname.isEmpty) return;

    final accessToken = await const FlutterSecureStorage().read(key: 'accessToken');
    final response = await http.post(
      Uri.parse('http://182.222.119.214:8081/api/members/join/verify-nickname'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({'nickname': nickname}),
    );

    if (response.statusCode == 200) {
      setState(() {
        isNicknameChecked = true;
        nicknameCheckResult = "✅ 사용 가능한 닉네임입니다.";
      });
    } else {
      final decoded = jsonDecode(response.body);
      setState(() {
        isNicknameChecked = false;
        nicknameCheckResult = "❌ " + decoded['message'];
      });
      print("닉네임 중복 검증 오류: ${decoded['message']}");
      print('응답 코드: ${response.statusCode}');
      print('응답 바디: ${response.body}');
    }

    _checkFormValid();
  }

  Future<void> _fetchUserProfile() async {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');

    if (accessToken == null) return;

    final response = await http.get(
      Uri.parse('http://182.222.119.214:8081/api/members/profile/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        idController.text = data['username'] ?? '';
        nameController.text = data['name'] ?? '';
        emailController.text = data['email'] ?? '';
        nicknameController.text = data['nickname'] ?? '';
        originalNickname = data['nickname'];
        ageController.text = (data['age'] ?? '').toString();
        locationController.text = data['location'] ?? '';
        selectedGender = data['gender'] == 'MALE' ? '남성' : data['gender'] == 'FEMALE' ? '여성' : '선택하세요';
        _checkFormValid();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserProfile().then((_) {
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
    });
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
          _buildReadOnlyField("이메일", emailController),
          const SizedBox(height: 4),
          const Text("수정할 수 없는 항목입니다.", style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 16),
          _buildEditableField("이름", nameController),
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
          const SizedBox(height: 150),
        ],
      ),
      floatingActionButton: FloatingButton(
        text: "수정 완료",
        onPressed: isFormValid
            ? () async {
                final genderCode = selectedGender == '남성' ? 'MALE' : selectedGender == '여성' ? 'FEMALE' : null;
                final accessToken = await const FlutterSecureStorage().read(key: 'accessToken');
                final response = await http.put(
                  Uri.parse('http://182.222.119.214:8081/api/members/profile/me'),
                  headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer $accessToken',
                  },
                  body: jsonEncode({
                    'username': idController.text,
                    'name': nameController.text,
                    'nickname': nicknameController.text,
                    'email' : emailController.text,
                    'age': int.tryParse(ageController.text),
                    'location': locationController.text,
                    'gender': genderCode,
                  }),
                );
                print('응답 상태 코드: ${response.statusCode}');
                print('응답 본문: ${response.body}');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditResultPage(
                      success: response.statusCode == 200 || response.statusCode == 204,
                      type: '회원 정보',
                    ),
                  ),
                );
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