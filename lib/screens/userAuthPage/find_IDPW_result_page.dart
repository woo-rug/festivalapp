import 'package:festivalapp/modules/base_layouts.dart';
import 'package:festivalapp/modules/button_modules.dart';
import 'package:flutter/material.dart';

class FindIDPWResultPage extends StatelessWidget {
  final bool isID;
  final bool? result;
  final String? message;

  const FindIDPWResultPage({
    super.key,
    required this.isID,
    this.result,
    this.message,
  });
  
  @override
  Widget build(BuildContext context) {
    final title = isID ? '아이디 찾기 결과' : '비밀번호 초기화 완료';

    return CurveScreen(
      title: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Center(
              child: isID
                ? Text(
                        '$message',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18),
                      )
                : (result == true
                    ? Text(
                        '비밀번호가 초기화되었습니다.\n임시 비밀번호가 이메일로 전송되었습니다.\n로그인 이후 비밀번호를 변경해주세요.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18),
                      )
                    : Text(
                        '$message',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18),
                      )),
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (result == false) ...[
                  GradientButton(
                    height: 60,
                    text: '뒤로가기',
                    isBlue: false,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 12),
                  GradientButton(
                    height: 60,
                    text: '로그인 화면으로',
                    isBlue: true,
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                  ),
                  const SizedBox(height: 12),
                  GradientButton(
                    height: 60,
                    text: '회원가입',
                    isBlue: false,
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                  ),
                ] else ...[
                  GradientButton(
                    height: 60,
                    text: '로그인 화면으로',
                    isBlue: true,
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
