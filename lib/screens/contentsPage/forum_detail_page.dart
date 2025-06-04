import 'package:festivalapp/modules/base_layouts.dart';
import 'package:flutter/material.dart';

class ForumDetailPage extends StatefulWidget {
  final int postId;
  final int category;

  const ForumDetailPage({Key? key, required this.postId, required this.category}) : super(key: key);

  @override
  State<ForumDetailPage> createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  bool _isLiked = false;
  int _likeCount = 12;
  int _commentCount = 5;
  bool _isMine = true;

  @override
  void initState() {
    super.initState();
    _fetchOwnership();
  }

  void _fetchOwnership() async {
    // TODO: 실제 서버 통신으로 본인 여부 확인
    // 예시 응답 처리
    await Future.delayed(Duration(milliseconds: 300));
    setState(() {
      _isMine = true; // 서버 응답값 기반
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlatScreen(
      appBar: Text(
        "게시글 상세",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 게시글 제목
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
              child: Text(
                '게시글 제목 예시',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            // 게시글 날짜/시간
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
              child: Text(
                '2024-06-01 12:34',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            // 게시글 내용
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 16.0),
              child: Text(
                '여기에 게시글 본문이 표시됩니다.\npostId: ${widget.postId}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            if (widget.category == 2) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isLiked = !_isLiked;
                              _likeCount += _isLiked ? 1 : -1;
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                _isLiked ? Icons.favorite : Icons.favorite_border,
                                color: _isLiked ? Colors.red : Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text('$_likeCount'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Row(
                          children: [
                            const Icon(Icons.comment, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text('$_commentCount'),
                          ],
                        ),
                      ],
                    ),
                    if (_isMine)
                      TextButton(
                        onPressed: () {
                          // 수정 기능 구현 예정
                        },
                        child: const Text(
                          '수정',
                        ),
                      ),
                  ],
                ),
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text(
                  '댓글',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                          print('댓글 입력: ${_commentController.text}');
                          _commentController.clear();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: 5, // 예시로 댓글 5개
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text('사용자 ${index + 1}'),
                      subtitle: const Text('댓글 내용입니다.'),
                    );
                  },
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}