import 'package:festivalapp/modules/postcode_page.dart';
import 'package:festivalapp/modules/title_modules.dart';
import 'package:festivalapp/screens/userAuthPage/register_additional_page.dart';
import 'package:festivalapp/screens/userAuthPage/register_result_page.dart';
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

  final idController = TextEditingController();
  final pwController = TextEditingController();
  final pwConfirmController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final emailController = TextEditingController();
  final emailCodeController = TextEditingController();
  final nicknameController = TextEditingController();
  final locationController = TextEditingController();
  String? selectedGender = '선택하세요';

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
          SignUpFormContent(
            onFormValidChange: updateFormFilled,
            idController: idController,
            pwController: pwController,
            pwConfirmController: pwConfirmController,
            nameController: nameController,
            ageController: ageController,
            emailController: emailController,
            emailCodeController: emailCodeController,
            nicknameController: nicknameController,
            locationController: locationController,
            selectedGender: selectedGender,
            onGenderChanged: (value) => setState(() {
              selectedGender = value;
            }),
          ),
          const SizedBox(height: 100),
        ],
      ),
      floatingActionButton: FloatingButton(
        text: "다음 페이지로",
        onPressed: isFormFilled
            ? () async {
                final response = await http.post(
                  Uri.parse('http://182.222.119.214:8081/api/members/join'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({
                    'username': idController.text,
                    'password': pwController.text,
                    'name': nameController.text,
                    'email': emailController.text,
                    'nickname': nicknameController.text,
                    'gender': genderToEnum(selectedGender),
                    'location': locationController.text,
                    'age': int.parse(ageController.text),
                    'authcode' : emailCodeController.text,
                  }),
                );

                if (response.statusCode == 201) {
                  print('응답 코드: ${response.statusCode}');
                  print('응답 바디: ${response.body}');
                  print(idController.text + ", " + pwController.text + ", " + nameController.text + ", " + emailController.text + ", " + nicknameController.text + ", " + genderToEnum(selectedGender) + ", " + locationController.text + ", " + ageController.text + ", " + emailCodeController.text + ", ");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegisterAdditionalPage(
                        name: nameController.text,
                        username: idController.text,
                      ),
                    ),
                  );
                } else {
                  print('응답 코드: ${response.statusCode}');
                  print('응답 바디: ${response.body}');
                  final decoded = jsonDecode(response.body);
                  print(idController.text + ", " + pwController.text + ", " + nameController.text + ", " + emailController.text + ", " + nicknameController.text + ", " + genderToEnum(selectedGender) + ", " + locationController.text + ", " + ageController.text + ", " + emailCodeController.text + ", ");
                  Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterResult(success: false, errorMessage: decoded['message'],)));
                }
              }
            : null,
        isBlue: isFormFilled,
      ),
    );
  }

  String genderToEnum(String? gender) {
    switch (gender) {
      case '남성':
        return 'MALE';
      case '여성':
        return 'FEMALE';
      default:
        return 'UNKNOWN';
    }
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
  final TextEditingController idController;
  final TextEditingController pwController;
  final TextEditingController pwConfirmController;
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController emailController;
  final TextEditingController emailCodeController;
  final TextEditingController nicknameController;
  final TextEditingController locationController;
  final String? selectedGender;
  final Function(String?) onGenderChanged;

  const SignUpFormContent({
    super.key,
    required this.onFormValidChange,
    required this.idController,
    required this.pwController,
    required this.pwConfirmController,
    required this.nameController,
    required this.ageController,
    required this.emailController,
    required this.emailCodeController,
    required this.nicknameController,
    required this.locationController,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  State<SignUpFormContent> createState() => _SignUpFormContentState();
}

class _SignUpFormContentState extends State<SignUpFormContent> {
  bool _isSendingEmail = false;
  final genderList = ['선택하세요', '남성', '여성'];

  bool? isPasswordMatch;
  bool isPasswordSafe = false;
  bool isIdAvailable = false;
  bool isNicknameAvailable = false;
  bool isEmailValid = true;
  bool isAgeValid = true;
  String? _idDuplicateMessage;
  String? _emailSendMessage;
  bool _emailEditable = true;
  String? _nicknameDuplicateMessage;
  void _validateAge(String value) {
    final age = int.tryParse(value);
    setState(() {
      isAgeValid = age != null && age >= 1 && age <= 120;
    });
    _checkAllFilled();
  }

  @override
  void initState() {
    super.initState();
    widget.pwController.addListener(() {
      _checkPasswordMatch();
      _checkAllFilled();
    });
    widget.pwConfirmController.addListener(() {
      _checkPasswordMatch();
      _checkAllFilled();
    });
  }

  void _checkPasswordMatch() {
    final pw = widget.pwController.text;
    final confirm = widget.pwConfirmController.text;
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$');

    setState(() {
      isPasswordMatch = (pw.isNotEmpty && confirm.isNotEmpty) ? pw == confirm : null;
      isPasswordSafe = regex.hasMatch(pw);
    });
    _checkAllFilled();
  }

  void _checkAllFilled() {
    bool idFilled = widget.idController.text.isNotEmpty;
    bool pwFilled = widget.pwController.text.isNotEmpty;
    bool pwConfirmFilled = widget.pwConfirmController.text.isNotEmpty;
    bool nameFilled = widget.nameController.text.isNotEmpty;
    bool ageFilled = widget.ageController.text.isNotEmpty;
    bool emailFilled = widget.emailController.text.isNotEmpty;
    bool emailCodeFilled = widget.emailCodeController.text.isNotEmpty;
    bool locationFilled = widget.locationController.text.isNotEmpty;
    bool nicknameFilled = widget.nicknameController.text.isNotEmpty;
    bool genderSelected = widget.selectedGender != null && widget.selectedGender != '선택하세요';

    bool filled =
        idFilled &&
        isIdAvailable &&
        pwFilled &&
        isPasswordSafe &&
        pwConfirmFilled &&
        isPasswordMatch == true &&
        nameFilled &&
        ageFilled &&
        emailFilled &&
        emailCodeFilled &&
        locationFilled &&
        nicknameFilled &&
        isNicknameAvailable &&
        isEmailValid &&
        genderSelected;

    print("idFilled: $idFilled");
    print("isIdAvailable: $isIdAvailable");
    print("pwFilled: $pwFilled");
    print("isPasswordSafe: $isPasswordSafe");
    print("pwConfirmFilled: $pwConfirmFilled");
    print("isPasswordMatch: $isPasswordMatch");
    print("nameFilled: $nameFilled");
    print("ageFilled: $ageFilled");
    print("emailFilled: $emailFilled");
    print("emailCodeFilled: $emailCodeFilled");
    print("locationFilled: $locationFilled");
    print("nicknameFilled: $nicknameFilled");
    print("isNicknameAvailable: $isNicknameAvailable");
    print("isEmailValid: $isEmailValid");
    print("genderSelected: ${widget.selectedGender}");

    widget.onFormValidChange(filled);
  }

  Future<void> _checkIdDuplicate() async {
    final response = await http.post(
      Uri.parse('http://182.222.119.214:8081/api/members/join/verify-username'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': widget.idController.text}),
    );
    if (response.statusCode == 200) {
      // success handling
      print("아이디 중복 검증 성공");
      setState(() {
        isIdAvailable = true;
        _idDuplicateMessage = "✅ 사용 가능한 아이디입니다.";
      });
    } else {
      // error handling
      final decoded = jsonDecode(response.body);
      setState(() {
        isIdAvailable = false;
        _idDuplicateMessage = "❌ " + decoded['message'];
      });
      print("아이디 중복 검증 오류: ${decoded['message']}");
      print('응답 코드: ${response.statusCode}');
      print('응답 바디: ${response.body}');
    }
    _checkAllFilled();
  }

  Future<void> _checkNicknameDuplicate() async {
    final response = await http.post(
      Uri.parse('http://182.222.119.214:8081/api/members/join/verify-nickname'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nickname': widget.nicknameController.text}),
    );

    if (response.statusCode == 200) {
      print("닉네임 중복 검증 성공");
      setState(() {
        isNicknameAvailable = true;
        _nicknameDuplicateMessage = "✅ 사용 가능한 닉네임입니다.";
      });
    } else {
      final decoded = jsonDecode(response.body);
      setState(() {
        isNicknameAvailable = false;
        _nicknameDuplicateMessage = "❌ " + decoded['message'];
      });
      print("닉네임 중복 검증 오류: ${decoded['message']}");
      print('응답 코드: ${response.statusCode}');
      print('응답 바디: ${response.body}');
    }
    _checkAllFilled();
  }

  Future<void> _sendEmailVerification() async {
    setState(() {
      _isSendingEmail = true;
    });
    final response = await http.post(
      Uri.parse('http://182.222.119.214:8081/api/members/join/send-email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': widget.emailController.text}),
    );
    setState(() {
      _isSendingEmail = false;
    });
    if (response.statusCode == 204) {
      print("이메일 보내기 위한 서버 접속 성공");
      setState(() {
        _emailSendMessage = "✅ 이메일이 성공적으로 전송되었습니다.";
      });
    } else {
      print(widget.emailController.text + "로 이메일 보내기");
      print('응답 코드: ${response.statusCode}');
      print('응답 바디: ${response.body}');
      print("이메일 서버 접속 실패");
      setState(() {
        _emailSendMessage = "❌ 이메일 전송에 실패했습니다.";
      });
    }
  }

  void _validateEmailFormat(String email) {
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    setState(() {
      isEmailValid = regex.hasMatch(email);
    });
    _checkAllFilled();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleModules.title("회원 정보 입력"),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              "계정 정보",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          // 1. 아이디 입력 + 중복확인
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: CommonTextField(
                  label: "아이디",
                  controller: widget.idController,
                  hintText: "아이디 입력",
                  onChanged: (_) => setState(() {
                    isIdAvailable = false;
                    _idDuplicateMessage = null;
                  }),
                ),
              ),
              const SizedBox(width: 8),
              GradientButton(text: '중복확인', onPressed: _checkIdDuplicate, isBlue: true, width: 150),
            ],
          ),
          if (_idDuplicateMessage != null)
            Padding(
              padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Text(
                _idDuplicateMessage!,
                style: TextStyle(
                  color: isIdAvailable ? Colors.green : Colors.red,
                  fontSize: 13,
                ),
              ),
            ),
          const SizedBox(height: 16),
          // 2. 이메일 입력 + 전송 버튼
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: CommonTextField(
                  label: "이메일",
                  controller: widget.emailController,
                  hintText: "이메일 입력",
                  onChanged: _validateEmailFormat,
                  readOnly: !_emailEditable,
                ),
              ),
              const SizedBox(width: 8),
              Stack(
                alignment: Alignment.center,
                children: [
                  GradientButton(
                    text: '이메일 보내기',
                    onPressed: _isSendingEmail ? null : _sendEmailVerification,
                    isBlue: true,
                    width: 150,
                  ),
                  if (_isSendingEmail)
                    const Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ],
          ),
          if (!isEmailValid)
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
              child: Text("❌ 이메일 형식이 맞지 않습니다.", style: TextStyle(color: Colors.red, fontSize: 13)),
            ),
          if (_emailSendMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _emailSendMessage!,
                style: TextStyle(
                  color: _emailSendMessage!.startsWith("✅") ? Colors.green : Colors.red,
                  fontSize: 13,
                ),
              ),
            ),
          const SizedBox(height: 16),
          // 3. 인증번호 입력 + 인증 버튼
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: CommonTextField(
                  label: "인증번호",
                  controller: widget.emailCodeController,
                  onChanged: (_) => _checkAllFilled(),
                ),
              ),
              const SizedBox(width: 8),
              GradientButton(
                text: '인증하기',
                onPressed: _verifyEmailCode,
                isBlue: true,
                width: 150,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 4. 비밀번호 + 확인
          CommonTextField(
            label: "비밀번호",
            controller: widget.pwController,
            hintText: "비밀번호",
            isPassword: true,
            onChanged: (_) => _checkAllFilled(),
          ),
          const SizedBox(height: 8),
          Text(
            isPasswordSafe ? "✅ 안전한 비밀번호입니다." : "❌ 최소 8자, 적어도 1개 이상의 영문, 숫자가 필요합니다.",
            style: TextStyle(color: isPasswordSafe ? Colors.green : Colors.red, fontSize: 13),
          ),
          const SizedBox(height: 8),
          CommonTextField(
            label: "비밀번호 확인",
            controller: widget.pwConfirmController,
            isPassword: true,
            onChanged: (_) => _checkAllFilled(),
          ),
          if (isPasswordMatch != null)
            Text(
              isPasswordMatch == true ? "비밀번호가 일치합니다." : "비밀번호가 일치하지 않습니다.",
              style: TextStyle(color: isPasswordMatch == true ? Colors.green : Colors.red, fontSize: 13),
            ),
          const SizedBox(height: 16),
          Divider(),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              "개인 정보",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          // 6. 이름
          CommonTextField(label: "이름", controller: widget.nameController, onChanged: (_) => _checkAllFilled()),
          const SizedBox(height: 16),
          // 7. 닉네임 + 중복확인
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: CommonTextField(
                  label: "닉네임",
                  controller: widget.nicknameController,
                  onChanged: (_) {
                    setState(() {
                      isNicknameAvailable = false;
                      _nicknameDuplicateMessage = null;
                    });
                    _checkAllFilled();
                  },
                ),
              ),
              const SizedBox(width: 8),
              GradientButton(text: '중복확인', onPressed: _checkNicknameDuplicate, isBlue: true, width: 150),
            ],
          ),
          if (_nicknameDuplicateMessage != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
              child: Text(
                _nicknameDuplicateMessage!,
                style: TextStyle(
                  color: isNicknameAvailable ? Colors.green : Colors.red,
                  fontSize: 13,
                ),
              ),
            ),
          const SizedBox(height: 16),
          // 8. 성별 (이제 나이보다 앞에 위치)
          DropdownButtonFormField<String>(
            value: widget.selectedGender,
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
                widget.onGenderChanged(value);
                _checkAllFilled();
              });
            },
          ),
          const SizedBox(height: 16),
          // 9. 나이 (성별 아래로 이동)
          CommonTextField(
            label: "나이",
            controller: widget.ageController,
            onChanged: _validateAge,
          ),
          if (!isAgeValid)
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
              child: Text("❌ 올바른 나이값을 입력하세요.", style: TextStyle(color: Colors.red, fontSize: 13)),
            ),
          if (!isAgeValid)
            const SizedBox(height: 16),
          if (isAgeValid)
            const SizedBox(height: 16),
          // 10. 주소 검색
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: CommonTextField(label: "주소", controller: widget.locationController, readOnly: true),
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
                      // Assume selectedAddress has a .roadAddress property.
                      widget.locationController.text = selectedAddress.roadAddress;
                    });
                    _checkAllFilled();
                  }
                },
                isBlue: true,
                width: 150,
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
  
  Future<void> _verifyEmailCode() async {
    final response = await http.post(
      Uri.parse('http://182.222.119.214:8081/api/members/join/verify-emailcode'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': widget.emailController.text,
        'authcode': widget.emailCodeController.text,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _emailEditable = false;
      });
      print("✅ 이메일 인증 성공");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ 이메일 인증이 완료되었습니다.")),
      );
    } else {
      final decoded = jsonDecode(response.body);
      print("❌ 이메일 인증 실패: ${decoded['message']}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ 이메일 인증 실패: ${decoded['message']}")),
      );
    }
  }
}
