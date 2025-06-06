import 'dart:convert';
import 'dart:async';
import 'package:festivalapp/screens/contentsPage/contents_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class KeywordSearchView extends StatefulWidget {
  const KeywordSearchView({super.key});

  @override
  State<KeywordSearchView> createState() => _KeywordSearchViewState();
}

class _KeywordSearchViewState extends State<KeywordSearchView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  List<Map<String, String>> _keywordFestivalList = [];
  String _selectedSort = 'favoriteCount';
  int _page = 0;
  final int _size = 20;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_isFetchingMore) {
        _fetchMoreFestivals();
      }
    });
    _sendSearchRequest(keyword: '');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<bool> _sendSearchRequest({String keyword = '', String? sortKey}) async {
    if (!mounted) return false;
    try {
      final token = await _storage.read(key: 'accessToken');
      final url = Uri.parse('http://182.222.119.214:8081/api/contents/search');
      _page = 0;

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'keyword': keyword,
          'page': _page,
          'size': _size,
          'sortBy': sortKey ?? _selectedSort,
        }),
      );

      print('검색 응답 코드: ${response.statusCode}');
      print('검색 응답 본문: ${utf8.decode(response.bodyBytes)}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes))['content'] ?? [];
        setState(() {
          _keywordFestivalList = data.map<Map<String, String>>((item) {
            final start = item['startDateTime']?.substring(0, 10) ?? '';
            final end = item['endDateTime']?.substring(0, 10) ?? '';
            final subtitle = "$start - $end";
            final imageUrl = (item['imageUrls'] != null && item['imageUrls'] is List && (item['imageUrls'] as List).isNotEmpty)
                ? item['imageUrls'][0] as String
                : '';
            return {
              'id': item['id'].toString(),
              'title': item['contentName'] ?? '',
              'subtitle': subtitle,
              'imageUrl': imageUrl,
            };
          }).toList();
        });
        return true;
      }
      return false;
    } catch (e) {
      print('검색 요청 오류: $e');
      return false;
    }
  }

  Future<void> _fetchMoreFestivals() async {
    _isFetchingMore = true;
    _page++;
    final token = await _storage.read(key: 'accessToken');
    final url = Uri.parse('http://182.222.119.214:8081/api/contents/search');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'page': _page,
          'size': _size,
          'sortBy': _selectedSort,
          'keyword': _searchController.text,
        }),
      );

      print('추가 로드 응답 코드: ${response.statusCode}');
      print('추가 로드 응답 본문: ${utf8.decode(response.bodyBytes)}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes))['content'] ?? [];
        setState(() {
          _keywordFestivalList.addAll(data.map<Map<String, String>>((item) {
            final start = item['startDateTime']?.substring(0, 10) ?? '';
            final end = item['endDateTime']?.substring(0, 10) ?? '';
            final subtitle = "$start - $end";
            final imageUrl = (item['imageUrls'] as List<dynamic>?)?.isNotEmpty == true
                ? item['imageUrls'][0] as String
                : '';
            return {
              'id': item['id'].toString(),
              'title': item['contentName'] ?? '',
              'subtitle': subtitle,
              'imageUrl': imageUrl,
            };
          }).toList());
        });
      }
    } catch (e) {
      print('더 불러오기 오류: $e');
    } finally {
      _isFetchingMore = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (value) => _sendSearchRequest(keyword: value),
                    decoration: InputDecoration(
                      hintText: '검색어를 입력하세요',
                      border: InputBorder.none,
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_searchController.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                                _sendSearchRequest(keyword: '');
                              },
                            ),
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              _sendSearchRequest(keyword: _searchController.text);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _selectedSort,
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                  iconSize: 16,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'favoriteCount', child: Text('좋아요순')),
                    DropdownMenuItem(value: 'startDateTime', child: Text('시작 일자순')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedSort = value;
                      });
                      _sendSearchRequest(keyword: _searchController.text, sortKey: value);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _sendSearchRequest(keyword: _searchController.text),
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 120),
              itemCount: _keywordFestivalList.length,
              itemBuilder: (context, index) {
                final festival = _keywordFestivalList[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  leading: CircleAvatar(
                    radius: 36,
                    backgroundImage: festival['imageUrl'] != ''
                        ? NetworkImage(festival['imageUrl']!)
                        : const AssetImage('assets/images/event1.jpg') as ImageProvider,
                  ),
                  title: Text(festival['title'] ?? ''),
                  subtitle: Text(festival['subtitle'] ?? ''),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContentsDetailPage(contentsID: festival['id']!),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) => const Divider(height: 1),
            ),
          ),
        ),
      ],
    );
  }
}