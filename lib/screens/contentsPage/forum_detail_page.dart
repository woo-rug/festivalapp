import 'dart:convert';
import 'package:festivalapp/auth/auth_provider.dart';
import 'package:festivalapp/auth/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:festivalapp/auth/auth_http_client.dart';
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
  Map<String, dynamic>? _postData;
  List<Map<String, dynamic>> _comments = [];
  String? _userId;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
    _fetchOwnership();
    _fetchPostDetail();
    _fetchComments();
  }

  void _fetchUserId() async {
    final String? accessToken = await AuthService().getAccessToken();
    final uri = Uri.parse('http://182.222.119.214:8081/api/members/profile/me');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    final decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _userId = decoded['nickname']?.toString();
      });
    }
  }

  void _fetchComments() async {
    final String? accessToken = await AuthService().getAccessToken();
    final uri = Uri.parse('http://182.222.119.214:8081/api/comments/${widget.postId}/comments');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    debugPrint('GET /api/comments/${widget.postId}/comments 응답 코드: ${response.statusCode}');
    if (response.statusCode == 200) {
      try {
        final decoded = jsonDecode(response.body);
        debugPrint('댓글 응답 본문: $decoded');
        for (var comment in decoded) {
          debugPrint('댓글 작성자: ${comment['memberName']}, 내용: ${comment['commentContent']}');
        }
        setState(() {
          _comments = List<Map<String, dynamic>>.from(decoded.map((comment) => {
            'commentId': comment['id'],
            'memberName': comment['memberName'],
            'commentContent': comment['commentContent'],
            'likeCount': comment['likeCount'],
            'createdDate': comment['createdDate'],
            'memberId': comment['memberId'],
            'liked': comment['liked'],
          }));
        });
      } catch (e) {
        debugPrint('댓글 JSON 디코딩 오류: $e');
      }
    } else {
      debugPrint('댓글 서버 응답 오류: ${response.body}');
    }
  }

  void _fetchPostDetail() async {
    final String? accessToken = await AuthService().getAccessToken();

    final uri = Uri.parse('http://182.222.119.214:8081/api/articles/detail/${widget.postId}');
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    debugPrint('GET /api/articles/detail/${widget.postId} 응답 코드: ${response.statusCode}');
    if (response.statusCode == 200) {
      try {
        final decoded = jsonDecode(response.body);
        debugPrint('응답 본문: $decoded');
        setState(() {
          _postData = {
            'title': decoded['title'],
            'createDate': decoded['createDate'],
            'body': decoded['body'],
            'likeCount': decoded['likeCount'],
            'commentCount': decoded['commentCount'],
            'memberId': decoded['memberId']?.toString(),
          };
          _isLiked = decoded['liked'] ?? false;
          _likeCount = decoded['likeCount'] ?? 0;
          _commentCount = decoded['commentCount'] ?? 0;
        });
      } catch (e) {
        debugPrint('JSON 디코딩 오류: $e');
      }
    } else {
      debugPrint('서버 응답 오류: ${response.body}');
    }
  }

  void _fetchOwnership() async {
    // TODO: 실제 서버 통신으로 본인 여부 확인
    // 예시 응답 처리
    await Future.delayed(Duration(milliseconds: 300));
    setState(() {
      _isMine = true; // 서버 응답값 기반
    });
  }

  void _toggleCommentLike(int commentId, int index) async {
    final String? accessToken = await AuthService().getAccessToken();
    final uri = Uri.parse('http://182.222.119.214:8081/api/comments/$commentId/like');
    debugPrint('POST 요청: $uri');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        final current = _comments[index];
        final liked = (current['liked'] as bool?) ?? false;
        final likeCount = (current['likeCount'] as int?) ?? 0;
        _comments[index]['liked'] = !liked;
        _comments[index]['likeCount'] = liked ? likeCount - 1 : likeCount + 1;
        print("댓글 좋아요 성공");
      });
    } else {
      debugPrint('댓글 좋아요 실패: ${response.body}');
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = _postData?['title'] ?? '제목 없음';
    final dateTimeRaw = _postData?['createDate']?.toString();
    String dateTime = '날짜 없음';
    if (dateTimeRaw != null) {
      try {
        final dt = DateTime.parse(dateTimeRaw).toLocal();
        dateTime = '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
                   '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      } catch (_) {
        dateTime = dateTimeRaw.replaceFirst('T', ' ');
      }
    }
    final body = _postData?['body'] ?? '내용 없음';
    final likeCount = _postData?['likeCount'] ?? 0;
    final commentCount = _postData?['commentCount'] ?? 0;
    _likeCount = likeCount;
    _commentCount = commentCount;
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
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            // 게시글 날짜/시간
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
              child: Text(
                dateTime,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            // 게시글 내용
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 16.0),
              child: Text(
                body,
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
                          onTap: _togglePostLike,
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
                    if (_userId != null && _userId == _postData?['memberId'])
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
                        onPressed: () async {
                          final String commentText = _commentController.text.trim();
                          if (commentText.isEmpty) return;

                          final String? accessToken = await AuthService().getAccessToken();
                          final uri = Uri.parse('http://182.222.119.214:8081/api/comments/${widget.postId}/comments');

                          final response = await http.post(
                            uri,
                            headers: {
                              'Content-Type': 'application/json',
                              'Authorization': 'Bearer $accessToken',
                            },
                            body: jsonEncode({'commentContent': commentText}),
                          );

                          debugPrint('POST /api/comments 응답 코드: ${response.statusCode}');
                          debugPrint('POST /api/comments 응답 본문: ${response.body}');

                          if (response.statusCode == 200 || response.statusCode == 201) {
                            _commentController.clear();
                            _fetchComments();
                          } else {
                            debugPrint('댓글 전송 실패');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _fetchComments();
                  },
                  child: ListView.builder(
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      // Extract and format createdDate
                      String formattedDate = '';
                      if (comment['createdDate'] != null) {
                        final dt = DateTime.tryParse(comment['createdDate']);
                        if (dt != null) {
                          formattedDate = dt.toLocal().toString().substring(0, 16);
                        }
                      }
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(comment['memberName'] ?? '익명'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formattedDate,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(comment['commentContent'] ?? ''),
                          ],
                        ),
                        trailing: SizedBox(
                          width: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(
                                  comment['liked'] == true ? Icons.favorite : Icons.favorite_border,
                                  color: comment['liked'] == true ? Colors.red : Colors.grey,
                                ),
                                onPressed: () {
                                  final rawId = comment['commentId'];
                                  final commentId = rawId is int ? rawId : int.tryParse(rawId.toString());
                                  debugPrint('하트 클릭됨 - commentId: $commentId (${commentId.runtimeType})');
                                  if (commentId != null) {
                                    _toggleCommentLike(commentId, index);
                                  } else {
                                    debugPrint('commentId 변환 실패: $rawId');
                                  }
                                },
                              ),
                              Text('${comment['likeCount'] ?? 0}'),
                              if (_userId != null && _userId == comment['memberName']?.toString())
                                PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      _editComment(comment['commentId'], comment['commentContent']);
                                    } else if (value == 'delete') {
                                      _deleteComment(comment['commentId']);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(value: 'edit', child: Text('수정')),
                                    const PopupMenuItem(value: 'delete', child: Text('삭제')),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
  void _editComment(int commentId, String currentContent) async {
    final TextEditingController controller = TextEditingController(text: currentContent);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('댓글 수정'),
        content: TextField(controller: controller, maxLines: 5),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
          TextButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('저장')),
        ],
      ),
    );

    if (result != null && result.trim().isNotEmpty) {
      final String? accessToken = await AuthService().getAccessToken();
      final uri = Uri.parse('http://182.222.119.214:8081/api/comments/comments/$commentId');

      final response = await http.put(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'commentContent': result.trim()}),
      );

      if (response.statusCode == 200) {
        _fetchComments();
      } else {
        debugPrint('댓글 수정 실패: ${response.body}');
      }
    }
  }

  void _deleteComment(int commentId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('댓글 삭제'),
        content: const Text('댓글을 삭제하시겠습니까?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('취소')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('삭제')),
        ],
      ),
    );

    if (confirm == true) {
      final String? accessToken = await AuthService().getAccessToken();
      final uri = Uri.parse('http://182.222.119.214:8081/api/comments/comments/$commentId');

      final response = await http.delete(
        uri,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 204) {
        _fetchComments();
      } else {
        debugPrint('댓글 삭제 실패: ${response.body}');
      }
    }
  }
  void _togglePostLike() async {
    final String? accessToken = await AuthService().getAccessToken();
    final uri = Uri.parse('http://182.222.119.214:8081/api/articles/${widget.postId}/like');
    debugPrint('게시글 좋아요 요청: $uri');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        _isLiked = !_isLiked;
        _likeCount += _isLiked ? 1 : -1;
        _postData?['likeCount'] = _likeCount;
      });
    } else {
      debugPrint('게시글 좋아요 실패: ${response.body}');
    }
  }
}

