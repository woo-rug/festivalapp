import 'dart:convert';
import 'package:festivalapp/auth/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:festivalapp/modules/base_layouts.dart';
import 'package:festivalapp/modules/button_modules.dart';
import 'package:festivalapp/screens/contentsPage/forum_detail_page.dart';
import 'package:festivalapp/screens/contentsPage/forum_write_page.dart';
import 'package:flutter/material.dart';

class ForumPage extends StatefulWidget {
  final int category; // 0:공지사항, 1:내가 쓴 글, 2:게시판
  final int? boardId;

  ForumPage({super.key, this.boardId, required this.category});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  List<Map<String, dynamic>> forums = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchForums();
  }

  Future<void> fetchForums() async {
    final String? accessToken = await AuthService().getAccessToken();

    if (widget.category == 0) {
      final uri = Uri.parse('http://182.222.119.214:8081/api/members/profile/announcement');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      debugPrint("GET /api/members/profile/announcement 응답 코드: ${response.statusCode}");
      debugPrint("GET /api/members/profile/announcement 응답 본문: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          forums = List<Map<String, dynamic>>.from(data);
        });
      }
    } else if (widget.category == 1) {
      final uri = Uri.parse('http://182.222.119.214:8081/api/members/profile/myarticle');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      debugPrint("GET /api/members/profile/myarticle 응답 코드: ${response.statusCode}");
      debugPrint("GET /api/members/profile/myarticle 응답 본문: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          forums = List<Map<String, dynamic>>.from(data);
        });
      }
    } else {
      final uri = Uri.parse('http://182.222.119.214:8081/api/articles/${widget.boardId}');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      debugPrint("get /api/articles/ 응답 코드: ${response.statusCode}");
      debugPrint("get /api/articles/ 응답 본문: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          forums = [data];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatScreen(
      appBar: Column(
        children: [
          SizedBox(height:10),
          Text(
            "게시판",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            widget.category == 0
            ? "공지사항"
            : widget.category == 1
                ? "내가 쓴 글"
                : "${widget.boardId} 게시판",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          )
        ],
      ),
      appBarHeight: 65,
      body: Padding(
        padding: EdgeInsets.only(top: 16),
        child: RefreshIndicator(
          onRefresh: fetchForums,
          child: ListView.builder(
            itemCount: forums.length,
            itemBuilder: (context, index) {
              final forum = forums[index];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ForumDetailPage(postId: forum['id'] is int ? forum['id'] : int.parse(forum['id'].toString()), category: 2),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (forum['title'] ?? '') as String,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              (forum['body'] ?? '') as String,
                              style: const TextStyle(fontSize: 13, color: Colors.black87),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  (forum['createDate'] ?? '').toString().split('T')[0],
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                if (widget.category != 0) ...[
                                  const SizedBox(width: 12),
                                  Icon(Icons.comment, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    (forum['commentCount'] ?? 0).toString(),
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(Icons.favorite, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    (forum['likeCount'] ?? 0).toString(),
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ]
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: widget.category == 2
          ? Padding(
              padding: const EdgeInsets.only(bottom: 90),
              child: GestureDetector(
                onTap: () {
                  // 글쓰기 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ForumWritePage(boardId: widget.boardId!,),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF64B5F6), Color(0xFF1976D2)],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.edit, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "게시글 쓰기",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }
}