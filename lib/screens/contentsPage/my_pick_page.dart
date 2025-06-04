import 'package:flutter/material.dart';
import 'package:festivalapp/modules/base_layouts.dart';
import 'package:festivalapp/screens/contentsPage/contents_detail_page.dart';

class MyPickPage extends StatefulWidget {
  const MyPickPage({super.key});

  @override
  State<MyPickPage> createState() => _MyPickPageState();
}

class _MyPickPageState extends State<MyPickPage> {
  late List<bool> _isLiked;

  @override
  void initState() {
    super.initState();
    _isLiked = List<bool>.filled(5, true);
  }

  @override
  Widget build(BuildContext context) {
    return FlatScreen(
      appBar: const Text(
        "찜한 행사", // 추후에 id값에 맞는 제목으로 수정해야 함.
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: 5, // 샘플용
        itemBuilder: (context, index) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ContentsDetailPage(contentsID: '2025 동국대학교 봄 대동제',)),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Row(
                    children: [
                      ClipOval(
                        child: Image.network(
                          'https://search.pstatic.net/common/?src=http%3A%2F%2Fimgnews.naver.net%2Fimage%2F5906%2F2025%2F01%2F01%2F0000038280_004_20250223165015175.jpg&type=sc960_832',
                          width: 55,
                          height: 55,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '2025 동국대학교 봄 대동제',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              '2025.05.21 - 2025.05.23',
                              style: TextStyle(fontSize: 15, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isLiked[index] ? Icons.favorite : Icons.favorite_border,
                          color: _isLiked[index] ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isLiked[index] = !_isLiked[index];
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),
            ],
          );
        },
      ),
    );
  }
}