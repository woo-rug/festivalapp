import 'package:festivalapp/modules/base_layouts.dart';
import 'package:festivalapp/screens/userAuthPage/check_PW_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FlatScreen(
      appBar: const Text(
        "프로필",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      body: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (_) => _ProfileHome(),
          );
        },
      ),
    );
  }
}

class _ProfileHome extends StatelessWidget {
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("닉네임", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    SizedBox(height: 2),
                    Text("홍길동", style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 14),
                    Row(
                      children: [
                        Text("남", style: TextStyle(fontSize: 12, color: Colors.blue)),
                        SizedBox(width: 8),
                        Text("hong1234@naver.com", style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                    ListTile(title: const Text("내가 쓴 글", style:TextStyle(fontSize: 14)), onTap: () {}),
                    ListTile(title: const Text("찜한 행사", style:TextStyle(fontSize: 14)), onTap: () {}),
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
                    ListTile(title: const Text("공지사항", style:TextStyle(fontSize: 14)), onTap: () {}),
                    ListTile(title: const Text("1:1 이메일 문의", style:TextStyle(fontSize: 14)), onTap: () {}),
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
