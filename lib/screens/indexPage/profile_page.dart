import 'package:festivalapp/modules/base_layouts.dart';
import 'package:festivalapp/screens/contentsPage/contents_detail_page.dart';
import 'package:festivalapp/screens/contentsPage/forum_page.dart';
import 'package:festivalapp/screens/contentsPage/my_pick_page.dart';
import 'package:festivalapp/screens/userAuthPage/check_PW_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final String contentsID = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => ContentsDetailPage(contentsID: contentsID),
          );
        }
        return MaterialPageRoute(
          builder: (_) => FlatScreen(
            appBar: const Text(
              "프로필",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            body: ProfileHomeBody(),
          ),
        );
      },
    );
  }
}

class ProfileHomeBody extends StatefulWidget {
  @override
  State<ProfileHomeBody> createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHomeBody> {
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');

    final response = await http.get(
      Uri.parse('http://182.222.119.214:8081/api/members/profile/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _userData = data;
      });
    } else {
      print('유저 정보를 불러오는 데 실패했습니다: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey),
          ),
          margin: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF64B5F6), Color(0xFF1976D2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.person, size: 55, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _userData == null
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userData?["nickname"] ?? "",
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _userData?["name"] ?? "",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Text(
                                (_userData?["gender"] == 'MALE'
                                    ? '남'
                                    : _userData?["gender"] == 'FEMALE'
                                        ? '여'
                                        : ''),
                                style: const TextStyle(fontSize: 12, color: Colors.blue),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _userData?["email"] ?? "",
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          )
                        ],
                      ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  title: const Text("계정 정보", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                  childrenPadding: EdgeInsets.zero,
                  collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
                  children: [
                    ListTile(
                      title: const Text("개인정보 / 프로필 수정", style: TextStyle(fontSize: 14)),
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (_) => const CheckPWPage(actionType: 'editProfile'),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text("비밀번호 재설정", style: TextStyle(fontSize: 14)),
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (_) => const CheckPWPage(actionType: 'resetPassword'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  title: const Text("나의 활동", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                  childrenPadding: EdgeInsets.zero,
                  collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
                  children: [
                    ListTile(
                      title: const Text("내가 쓴 글", style: TextStyle(fontSize: 14)),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ForumPage(category: 1, boardId: 0),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text("찜한 행사", style: TextStyle(fontSize: 14)),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MyPickPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  title: const Text("고객센터", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                  childrenPadding: EdgeInsets.zero,
                  collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
                  children: [
                    ListTile(
                      title: const Text("공지사항", style: TextStyle(fontSize: 14)),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ForumPage(category: 0, boardId: 0),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text("1:1 이메일 문의", style: TextStyle(fontSize: 14)),
                      onTap: () async {
                        final Uri emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: 'support@example.com',
                          queryParameters: {
                            'subject': '1:1 문의',
                            'body': '문의 내용을 작성해주세요.'
                          },
                        );
                        if (await canLaunchUrl(emailLaunchUri)) {
                          await launchUrl(emailLaunchUri);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('이메일 앱을 열 수 없습니다.')),
                          );
                        }
                      },
                    ),
                    ListTile(title: const Text("행사 정보 추가 요청", style:TextStyle(fontSize: 14)), onTap: () {}),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  title: const Text("기타", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                  childrenPadding: EdgeInsets.zero,
                  collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
                  children: [
                    ListTile(title: const Text("로그아웃", style:TextStyle(fontSize: 14)), onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('로그아웃 하시겠습니까?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('취소'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('로그아웃'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        final storage = FlutterSecureStorage();
                        final allValues = await storage.readAll();
                          allValues.forEach((key, value) {
                            print('$key: $value');
                          });
                        await storage.deleteAll();
                        Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil('/login', (route) => false);
                      }
                    },),
                    ListTile(title: const Text("회원 탈퇴", style:TextStyle(fontSize: 14)), onTap: () {}),
                  ],
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ],
    );
  }
}
