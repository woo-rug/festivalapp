import 'package:festivalapp/base_layouts.dart';
import 'package:festivalapp/button_modules.dart';
import 'package:festivalapp/slider_modules.dart';
import 'package:festivalapp/title_modules.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FlatScreen(
      appBarHeight: 100, // 앱 아이콘 크기에 맞춰서 변경해야 할 부분분
      appBar : Container( // 앱 아이콘 삽입 부분분
        height:60,
        width:60,
        color:Colors.grey,
        child: Center(
          child: Text(
            "아이콘",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w100,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(height: 16),
          CardSliderWithStaticDots(), // 눌렀을 때 애니메이션 효과는 일단 보류
          TitleModules.title("AI가 추천하는 문화생활"),
          LeftAlignedSnapSlider(
            items: [
              RecommandResultButton(
                imagePath: 'assets/images/ai_recommend1.jpg',
                title: 'AI 추천 문화생활 1',
                dateRange: '2025.01.01 ~ 01.10',
              ),
              RecommandResultButton(
                imagePath: 'assets/images/ai_recommend2.jpg',
                title: 'AI 추천 문화생활 2',
                dateRange: '2025.01.01 ~ 01.10',
              ),
              RecommandResultButton(
                imagePath: 'assets/images/ai_recommend3.jpg',
                title: 'AI 추천 문화생활 3',
                dateRange: '2025.01.01 ~ 01.10',
              ),
            ],
          ),
          SizedBox(height:1500),
        ],
      ),
    );
  }
}
