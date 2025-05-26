import 'package:festivalapp/main_page.dart';
import 'package:flutter/material.dart';
import 'page_indexer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF1976D2),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF1976D2),
          ),
        fontFamily: 'Noto Sans KR',
      ),
      home: PageIndexer(
        pages: const [
          MainPage(),
          Center(child: Text('탐색 페이지')),
          Center(child: Text('폭죽 페이지')),
          Center(child: Text('기록 페이지')),
          Center(child: Text('프로필 페이지')),
        ],
      ),
    );
  }
}
