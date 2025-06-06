import 'dart:io';
import 'package:festivalapp/auth/auth_provider.dart';
import 'package:festivalapp/screens/indexPage/profile_page.dart';
import 'package:festivalapp/screens/indexPage/search_page.dart';
import 'package:provider/provider.dart';
import 'package:festivalapp/modules/postcode_page.dart';
import 'package:festivalapp/screens/userAuthPage/login_page.dart';
import 'package:festivalapp/screens/indexPage/main_page.dart';
import 'package:festivalapp/screens/userAuthPage/register_additional_page.dart';
import 'package:festivalapp/screens/userAuthPage/register_agree_page.dart';
import 'package:festivalapp/screens/userAuthPage/register_form_page.dart';
import 'package:festivalapp/screens/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'modules/page_indexer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
        fontFamily: 'NotoSansKR',
      ),
      initialRoute: '/',
      routes:{
        '/': (context) => const SplashPage(),
        '/login': (context) => LoginPage(),
        '/register_agree': (context) => RegisterAgreePage(),
        '/main': (context) => PageIndexer(
          pages: const [
            MainPage(),
            SearchPage(),
            ProfilePage(),
          ],
        ),
        '/map' : (context) => PostcodePage(),
      }
      // home: PageIndexer(
      //   pages: const [
      //     MainPage(),
      //     Center(child: Text('탐색 페이지')),
      //     Center(child: Text('폭죽 페이지')),
      //     Center(child: Text('기록 페이지')),
      //     Center(child: Text('프로필 페이지')),
      //   ],
      // ),
    );
  }
}
