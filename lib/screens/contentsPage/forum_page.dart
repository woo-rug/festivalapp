import 'package:festivalapp/modules/base_layouts.dart';
import 'package:festivalapp/screens/contentsPage/forum_detail_page.dart';
import 'package:flutter/material.dart';

class ForumPage extends StatelessWidget {
  final int boardId;

  ForumPage({super.key, required this.boardId});

  final List<Map<String, dynamic>> forums = [
    {"id": 1, "title": "축제 후기 공유해요"},
    {"id": 2, "title": "팁 공유 게시판"},
    {"id": 3, "title": "자유 게시판"},
  ];

  @override
  Widget build(BuildContext context) {
    return FlatScreen(
      appBar: const Text("게시판"),
      body: ListView.builder(
        itemCount: forums.length,
        itemBuilder: (context, index) {
          final forum = forums[index];
          return ListTile(
            title: Text(forum['title']),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ForumDetailPage(postId: forum['id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}