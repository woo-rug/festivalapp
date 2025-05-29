import 'package:festivalapp/modules/postcode_page.dart';
import 'package:festivalapp/screens/userAuthPage/login_page.dart';
import 'package:festivalapp/screens/main_page.dart';
import 'package:festivalapp/screens/userAuthPage/register_agree_page.dart';
import 'package:festivalapp/screens/userAuthPage/register_form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'modules/page_indexer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // 웹뷰 초기화
WebViewPlatform.instance = AndroidWebViewPlatform();

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
      initialRoute: '/map',
      routes:{
        '/login': (context) => LoginPage(),
        '/register_agree': (context) => RegisterAgreePage(),
        //'/register_form': (context) => RegisterFormPage(),
        //'register_additional': (context) => RegisterFormPage(isAdditional: true),
        '/main': (context) => MainPage(),
        '/map' : (context) => PostcodePage(onAddressSelected: (String fullAddress) {  },),
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
