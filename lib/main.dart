import 'package:festivalapp/base_layouts.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'NotoSansKR',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: FlatScreen(
        appBar: AppBar(
          title: const Text("회원가입"),
          backgroundColor: Colors.transparent,
        ),
        body: Text("회원가입 화면"),
        bottomNavigationBar: null,
      ),
    );
  }
}