import 'package:festivalapp/modules/button_modules.dart';
import 'package:flutter/material.dart';
import 'package:festivalapp/modules/base_layouts.dart';

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
                onPressed: () {}, 
                isBlue: true)
            )
          ],
        ),
      ),
    ),
    );
  }
}