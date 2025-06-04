import 'package:festivalapp/modules/base_layouts.dart';
import 'package:festivalapp/modules/button_modules.dart';
import 'package:festivalapp/screens/contentsPage/forum_detail_page.dart';
import 'package:festivalapp/screens/contentsPage/forum_write_page.dart';
import 'package:flutter/material.dart';

class ForumPage extends StatelessWidget {
  final int category; // 0:공지사항, 1:내가 쓴 글, 2:게시판
  final int? boardId;

  ForumPage({super.key, this.boardId, required this.category});

  final List<Map<String, dynamic>> forums = [
    {"id": 1, "title": "축제 후기 공유해요"},
    {"id": 2, "title": "팁 공유 게시판"},
    {"id": 3, "title": "자유 게시판"},
  ];

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
            category == 0
            ? "공지사항"
            : category == 1
                ? "내가 쓴 글"
                : "$boardId 게시판",
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
                      builder: (_) => ForumDetailPage(postId: forum['id'], category: 2,),
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
                            forum['title'],
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            '여기에 간단한 본문 내용이 표시됩니다.',
                            style: TextStyle(fontSize: 13, color: Colors.black87),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                "2025.06.04", // 날짜
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              if (category != 0) ...[
                                const SizedBox(width: 12),
                                Icon(Icons.comment, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  "3", // 댓글 수
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                const SizedBox(width: 12),
                                Icon(Icons.favorite, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  "10", // 좋아요 수
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
      floatingActionButton: category == 2
          ? Padding(
              padding: const EdgeInsets.only(bottom: 90),
              child: GestureDetector(
                onTap: () {
                  // 글쓰기 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ForumWritePage(boardId: boardId!,),
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