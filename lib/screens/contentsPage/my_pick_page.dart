import 'package:festivalapp/auth/auth_http_client.dart';
import 'package:festivalapp/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:festivalapp/modules/base_layouts.dart';
import 'package:festivalapp/screens/contentsPage/contents_detail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class MyPickPage extends StatefulWidget {
  const MyPickPage({super.key});

  @override
  State<MyPickPage> createState() => _MyPickPageState();
}

class _MyPickPageState extends State<MyPickPage> {
  late List<dynamic> _favoriteList = [];

  Future<void> _fetchFavorites() async {
    final client = AuthHttpClient(context.read<AuthProvider>(), context);
    final response = await client.get(Uri.parse('http://182.222.119.214:8081/api/members/profile/mycontent'));
    debugPrint('GET /api/favorites 응답 코드: ${response.statusCode}');
    debugPrint('GET /api/favorites 응답 본문: ${response.body}');
    if (response.statusCode == 200) {
      setState(() {
        _favoriteList = jsonDecode(response.body);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return FlatScreen(
      appBar: const Text(
        "찜한 행사",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      body: _favoriteList.isEmpty
          ? const Padding(
              padding: EdgeInsets.only(top: 300),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '찜한 행사가 없습니다.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _fetchFavorites,
              child: ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: _favoriteList.length,
          itemBuilder: (context, index) {
            final item = _favoriteList[index];
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ContentsDetailPage(contentsID: item['id'].toString()),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      children: [
                        ClipOval(
                          child: Image.network(
                            item['imageUrls'] != null && item['imageUrls'].isNotEmpty ? item['imageUrls'][0] : '',
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
                                item['contentName'] ?? '',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${(item['startDateTime'] ?? '').toString().split('T')[0]} - ${(item['endDateTime'] ?? '').toString().split('T')[0]}',
                                style: const TextStyle(fontSize: 15, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () async {
                            final client = AuthHttpClient(context.read<AuthProvider>(), context);
                            final toggleRes = await client.post(Uri.parse('http://182.222.119.214:8081/api/favorites/${item['id']}'));
                            debugPrint('POST /api/favorites/${item['id']} 응답 코드: ${toggleRes.statusCode}');
                            debugPrint('POST /api/favorites/${item['id']} 응답 본문: ${toggleRes.body}');
                            if (toggleRes.statusCode == 200) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('찜 해제되었습니다')),
                              );
                              _fetchFavorites();
                            }
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
      ),
    );
  }
}