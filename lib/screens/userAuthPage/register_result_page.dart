import 'package:festivalapp/screens/userAuthPage/login_page.dart';
import 'package:festivalapp/screens/userAuthPage/register_agree_page.dart';

import '../../modules/base_layouts.dart';
import '../../modules/button_modules.dart';
import 'package:flutter/material.dart';

class RegisterResult extends StatelessWidget {
  final bool success;

  const RegisterResult({
    required this.success,
    super.key,
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
          const Text(
            "(오류 메세지)",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          )
        ],
      )
      ,
      body: success ? 
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Container(
          decoration: BoxDecoration(color: Colors.grey),
          height: 300,
          width: 300,
        ),
        SizedBox(height:16),
        GradientButton(text: "로그인 화면으로", onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (_) => LoginPage()));}, isBlue: true, height:55, width:350),
      ],):
      Column(children: [
        GradientButton(text: "로그인 화면으로", onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (_) => LoginPage()));}, isBlue: true, height:55, width:350),
        GradientButton(text: "회원가입 화면으로", onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (_) => RegisterAgreePage()));}, isBlue: false, height:55, width:350)
      ],)
      ,
    );
  }
}

