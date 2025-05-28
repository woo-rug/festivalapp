import 'base_layouts.dart';
import 'button_modules.dart';
import 'package:flutter/material.dart';

class RegisterFormPage extends StatelessWidget {
  const RegisterFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FlatScreen( // base_layouts.dart에서 정의된 FlatScreen 위젯 사용
      appBarHeight: 80, // 앱바 높이, 따로 설정할 필요 없다면 삭제하시면 됩니다!
      appBar : AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // 앱바의 아이콘 색상, 변경 안하셔도 됩니다.
        ),
        title: Text(
          "회원가입", // 여기 부분만 페이지에 맞게 수정하시면 됩니다!
          style: TextStyle( // 굳이 건드릴 필요 없을 것 같습니다!
            fontSize: 18, // 앱바의 글자 크기
            fontWeight: FontWeight.w700, // 앱바의 글자 두께
            color: Colors.white, // 앱바의 글자 색상
          ),
        ),
        centerTitle: true, // 앱바 글자 중앙 정렬
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          //필요하신 위젯을 여기에 추가하시면 됩니다! ListView 아니어도 괜찮고 편하신 모듈로 사용하시면 되는데,
          // ListView가 스크롤이 가능해서 이걸 중심으로 사용하시는 것을 추천드리긴 합니다.

          SizedBox(height: 16), // 위젯 사이 간격 조정, 윗부분에 간격 두는 용도

          //const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0),child: SelectableTabRow(),), //한 라인 두 버튼 위젯
          //const ScrollableTextList(),//그냥 테스트용 의미없음
          //const TermsAgreementSection(),//약관 동의 화면 위젯
          SignUpFormContent(), //정보 입력 화면 위젯
          //AdditionalInfoSection(userName: "홍길동"),//추가 정보 입력 화면 위젯
          //IdResultBox(userName: "홍길동", userId: "abc123",),//투명 둥근 네모 박스 위젯

          SizedBox(height: 16), // 위젯 사이 간격 조정, 윗부분에 간격 두는 용도

          GradientButton(//각 페이지 위젯 번호 부여하고 수정
            text: "다음 페이지로",
            onPressed: () {
              Navigator.pop(context); // 버튼 사용 예제, 이전 페이지로 이동
            },
          )
        ],
      ),
    );
  }
}


//정보 입력 텍스트박스 위젯
class CommonTextField extends StatefulWidget {
  final String? label; // 제목 (null이면 없음)
  final bool isPassword; // 비밀번호용 입력인지
  final TextEditingController controller;
  final String? hintText;

  const CommonTextField({
    super.key,
    this.label,
    this.isPassword = false,
    required this.controller,
    this.hintText,
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
          obscureText: _obscure,
          decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 12,
            ),
          ),
        ),
      ],
    );
  }
}

//정보 입력 위젯(위의 텍스트박스 위젯 사용)
class SignUpFormContent extends StatefulWidget {
  const SignUpFormContent({super.key});

  @override
  State<SignUpFormContent> createState() => _SignUpFormContentState();
}

class _SignUpFormContentState extends State<SignUpFormContent> {
  final idController = TextEditingController();
  final pwController = TextEditingController();
  final pwConfirmController = TextEditingController();
  final nameController = TextEditingController();
  final nicknameController = TextEditingController();
  final phoneController = TextEditingController();

  bool? isPasswordMatch;

  @override
  void initState() {
    super.initState();
    pwController.addListener(_checkPasswordMatch);
    pwConfirmController.addListener(_checkPasswordMatch);
  }

  void _checkPasswordMatch() {
    final pw = pwController.text;
    final confirm = pwConfirmController.text;

    setState(() {
      isPasswordMatch = (pw.isNotEmpty && confirm.isNotEmpty) ? pw == confirm : null;
    });
  }

  @override
  void dispose() {
    idController.dispose();
    pwController.dispose();
    pwConfirmController.dispose();
    nameController.dispose();
    nicknameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Text(
            "정보 입력",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextField(
                label: "아이디",
                controller: idController,
                hintText: "아이디를 입력하세요",
              ),
              const SizedBox(height: 8),
              const Text(
                "사용 가능한 아이디입니다.",
                style: TextStyle(color: Colors.green, fontSize: 13),
              ),
              const SizedBox(height: 16),

              CommonTextField(
                label: "비밀번호",
                controller: pwController,
                hintText: "비밀번호를 입력하세요",
                isPassword: true,
              ),
              const SizedBox(height: 8),
              const Text(
                "✅ 안전한 비밀번호입니다.",
                style: TextStyle(color: Colors.green, fontSize: 13),
              ),
              const SizedBox(height: 16),

              CommonTextField(
                label: "비밀번호 확인",
                controller: pwConfirmController,
                isPassword: true,
              ),
              const SizedBox(height: 8),
              if (isPasswordMatch == true)
                const Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.green, size: 16),
                    SizedBox(width: 4),
                    Text(
                      "비밀번호가 일치합니다.",
                      style: TextStyle(color: Colors.green, fontSize: 13),
                    ),
                  ],
                )
              else if (isPasswordMatch == false)
                const Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 16),
                    SizedBox(width: 4),
                    Text(
                      "비밀번호가 일치하지 않습니다.",
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ],
                ),
              const SizedBox(height: 16),

              CommonTextField(
                label: "이름",
                controller: nameController,
              ),
              const SizedBox(height: 16),

              CommonTextField(
                label: "닉네임",
                controller: nicknameController,
              ),
              const SizedBox(height: 16),

              CommonTextField(
                label: "전화번호",
                controller: phoneController,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
