

import 'package:festivalapp/modules/base_layouts.dart';
import 'package:flutter/material.dart';

class ForumDetailPage extends StatefulWidget {
  final int postId;

  const ForumDetailPage({Key? key, required this.postId}) : super(key: key);

  @override
  State<ForumDetailPage> createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlatScreen(
      appBar: Text('게시글 상세'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 게시글 내용 영역
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '여기에 게시글 본문이 표시됩니다.\npostId: ${widget.postId}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '댓글',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: 5, // 예시로 댓글 5개
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text('사용자 ${index + 1}'),
                  subtitle: const Text('댓글 내용입니다.'),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: '댓글을 입력하세요...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // 댓글 전송 처리
                    print('댓글 입력: ${_commentController.text}');
                    _commentController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}