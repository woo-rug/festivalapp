import 'package:festivalapp/screens/userAuthPage/login_page.dart';
import 'package:festivalapp/screens/userAuthPage/register_agree_page.dart';

import '../../modules/base_layouts.dart';
import '../../modules/button_modules.dart';
import 'package:flutter/material.dart';

class RegisterResult extends StatelessWidget {
  final bool success;
  final String? errorMessage;

  const RegisterResult({
    required this.success,
    super.key,
    this.errorMessage = "오류가 발생했습니다.",
  });

  @override
  Widget build(BuildContext context) {
    return CurveScreen(
      title: success ?
      Column(
        children: [
          const Text(
            "회원가입 완료",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height:16),
          const Text(
            "만나서 반가워요! 이제부터 문화생활을 즐기러 가볼까요?",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          )
        ],
      ) : 
      Column(
        children: [
          const Text(
            "회원가입 실패",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12,),
          Text(
            errorMessage!,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          )
        ],
      )
      ,
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
        child: success ? 
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.grey),
                height: 300,
                width: 300,
              ),
              SizedBox(height:16),
              GradientButton(text: "로그인 화면으로", onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (_) => LoginPage()));}, isBlue: true, height:55, width:350),
            ],):
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height:72),
              GradientButton(text: "로그인 화면으로", onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (_) => LoginPage()));}, isBlue: true, height:55, width:350),
              SizedBox(height:12),
              GradientButton(text: "회원가입 화면으로", onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (_) => RegisterAgreePage()));}, isBlue: false, height:55, width:350)
            ],
          ),
      )
    );
  }
}

