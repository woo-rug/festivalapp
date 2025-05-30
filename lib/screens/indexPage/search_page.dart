import 'package:festivalapp/modules/base_layouts.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FlatScreen(
      appBar : const Text(
        "탐색",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      body: ListView(
        children: [
          Container(height: 16),
          Container( // 내용 변경
            height: 1750,
            decoration: BoxDecoration(gradient : LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black12, Colors.black])),
            child: Text("검색 페이지"),
          ),
        ],
      ),
    );
  }
}
