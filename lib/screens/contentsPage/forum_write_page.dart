import 'dart:convert';
import 'package:festivalapp/auth/auth_provider.dart';
import 'package:http/http.dart';
import 'package:festivalapp/auth/auth_http_client.dart';
import 'package:festivalapp/modules/button_modules.dart';
import 'package:flutter/material.dart';
import 'package:festivalapp/modules/base_layouts.dart';
late final AuthProvider _authProvider = AuthProvider();

class ForumWritePage extends StatefulWidget {
  final int boardId;
  const ForumWritePage({super.key, required this.boardId});

  @override
  State<ForumWritePage> createState() => _ForumWritePageState();
}

class _ForumWritePageState extends State<ForumWritePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final boardId = widget.boardId;
    return WillPopScope(
      onWillPop: () async {
        if (_titleController.text.isNotEmpty || _contentController.text.isNotEmpty) {
          final shouldExit = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("작성 중인 내용이 있습니다"),
              content: const Text("지금 나가면 작성한 내용이 사라집니다. 정말 나가시겠습니까?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("취소"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("나가기"),
                ),
              ],
            ),
          );
          return shouldExit ?? false;
        }
        return true;
      },
      child: FlatScreen(
      appBar: Column(
        children: [
          SizedBox(height:10),
          Text(
            "게시글 작성",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            "$boardId 게시판",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          )
        ],
      ),
      appBarHeight: 65,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text("제목", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "제목을 입력하세요",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Text("내용", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _contentController,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: "내용을 입력하세요",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: GradientButton(
                height: 55,
                text: "게시", 
                onPressed: () async {
                  final title = _titleController.text.trim();
                  final content = _contentController.text.trim();

                  if (title.isEmpty || content.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("제목과 내용을 모두 입력해주세요.")),
                    );
                    return;
                  }

                  try {
                    final uri = Uri.parse("http://182.222.119.214:8081/api/articles/");
                    final response = await AuthHttpClient(_authProvider, context).send(
                      Request(
                        "POST",
                        uri,
                      )..headers.addAll({
                          "Content-Type": "application/json",
                        })..body = jsonEncode({
                          "title": title,
                          "body": content,
                          "subCategoryId": widget.boardId,
                          "category": "FREE"
                        }),
                    );

                    final statusCode = response.statusCode;
                    final responseBody = await response.stream.bytesToString();
                    print("게시글 작성 응답 코드: $statusCode");
                    print("게시글 작성 응답 본문: $responseBody");

                    if (statusCode == 201) {
                      Navigator.of(context).pop(true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("게시글이 성공적으로 작성되었습니다.")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("게시글 작성에 실패했습니다.")),
                      );
                    }
                  } catch (e) {
                    print("게시글 작성 오류: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("네트워크 오류가 발생했습니다.")),
                    );
                  }
                },
                isBlue: true)
            )
          ],
        ),
      ),
    ),
    );
  }
}