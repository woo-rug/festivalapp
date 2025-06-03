import 'package:festivalapp/modules/page_indexer.dart';
import 'package:festivalapp/screens/indexPage/main_page.dart';
import 'package:festivalapp/screens/indexPage/profile_page.dart';
import 'package:festivalapp/screens/indexPage/search_page.dart';
import 'package:flutter/material.dart';
import 'package:festivalapp/modules/base_layouts.dart';
import 'package:festivalapp/modules/button_modules.dart';

class EditResultPage extends StatelessWidget {
  final bool success;
  final String type;

  const EditResultPage({super.key, required this.success, required this.type});

  @override
  Widget build(BuildContext context) {
    return CurveScreen(
      title: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            "$type ${success ? '변경 완료' : '변경 실패'}",
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const Spacer(),
            Text(
              "$type가 ${success ? '성공적으로 수정되었습니다.' : '실패했습니다. 다시 시도해주세요.'}",
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            GradientButton(
              height: 60,
              text: "메인으로",
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const PageIndexer(pages: [MainPage(), SearchPage(), ProfilePage()],)),
                  (route) => false,
                );
              },
              isBlue: true,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}