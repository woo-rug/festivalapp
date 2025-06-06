import 'dart:convert';
import 'package:festivalapp/screens/contentsPage/contents_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CategorySearchView extends StatefulWidget {
  const CategorySearchView({super.key});

  @override
  State<CategorySearchView> createState() => _CategorySearchViewState();
}

class _CategorySearchViewState extends State<CategorySearchView> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final Map<String, List<String>> subcategories = {
    '스포츠': ['축구', '야구', '농구'],
    '공연': ['뮤지컬', '콘서트', '연극'],
    '전시회': ['체험형', '팝 컬처', '기획전'],
    '팝업 스토어': ['음식', '패션', '뷰티'],
    '축제': ['대학 축제', '지역 축제'],
  };

  final Map<String, int> categoryIdMap = {
    '스포츠': 1,
    '공연': 2,
    '전시회': 3,
    '팝업 스토어': 4,
    '축제': 5,
  };

  final Map<String, int> subcategoryIdMap = {
    '축구': 1,
    '야구': 2,
    '농구': 3,
    '뮤지컬': 4,
    '콘서트': 5,
    '연극': 6,
    '체험형': 7,
    '팝 컬처': 8,
    '기획전': 9,
    '음식': 10,
    '패션': 11,
    '뷰티': 12,
    '대학 축제': 13,
    '지역 축제': 14,
  };

  int _getCategoryColorIndex(String category) {
    switch (category) {
      case '스포츠':
        return 6; // blue-grey toned
      case '공연':
        return 10; // teal toned
      case '전시회':
        return 0; // red toned
      case '축제':
        return 4; // purple toned
      case '팝업 스토어':
        return 12; // orange-yellow toned
      default:
        return categoryIdMap[category]! * 2 % Colors.primaries.length;
    }
  }

  String? _selectedCategory;
  int? _selectedCategoryId;
  int? _selectedSubcategoryId;
  List<String> _selectedSubcategories = [];
  List<Map<String, String>> _categoryFestivalList = [];
  bool _showFestivalList = false;
  bool _isLoadingSubcategory = false;

  Future<void> _sendCategorySelectionToServer(int subcategoryId) async {
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
          'subCategoryId': subcategoryId,
          'sortBy': 'startDateTime',
        }),
      );
      print('카테고리 선택 전송 본문: $subcategoryId');
      print('카테고리 선택 응답 코드: ${response.statusCode}');
      print('카테고리 선택 응답 본문: ${utf8.decode(response.bodyBytes)}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes))['content'] ?? [];
        setState(() {
          _categoryFestivalList = data.map<Map<String, String>>((item) {
            final start = item['startDateTime']?.substring(0, 10) ?? '';
            final end = item['endDateTime']?.substring(0, 10) ?? '';
            final subtitle = (end != '') ? "$start - $end" : "$start";
            final imageUrl = (item['imageUrls'] as List<dynamic>?)?.isNotEmpty == true
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
      }
    } catch (e) {
      print('카테고리 선택 오류: $e');
    }
  }

  void _navigateToSubcategories(String category) {
    setState(() {
      _selectedCategory = category;
      _selectedCategoryId = categoryIdMap[category];
      _selectedSubcategories = subcategories[category] ?? [];
      _showFestivalList = false;
    });
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case '스포츠':
        return Icons.sports_soccer;
      case '공연':
        return Icons.music_note;
      case '전시회':
        return Icons.museum;
      case '팝업 스토어':
        return Icons.storefront;
      case '축제':
        return Icons.celebration;
      default:
        return Icons.category;
    }
  }

  IconData _getSubcategoryIcon(String sub) {
    switch (sub) {
      case '축구':
      case '야구':
      case '농구':
        return Icons.sports;
      case '뮤지컬':
      case '콘서트':
      case '연극':
        return Icons.theater_comedy;
      case '체험형':
        return Icons.handshake;
      case '팝 컬처':
        return Icons.tv;
      case '기획전':
        return Icons.lightbulb;
      case '음식':
        return Icons.fastfood;
      case '패션':
        return Icons.checkroom;
      case '뷰티':
        return Icons.brush;
      case '대학 축제':
      case '지역 축제':
        return Icons.festival;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
        if (_selectedCategory != null)
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_showFestivalList) {
                      _showFestivalList = false;
                    } else {
                      _selectedCategory = null;
                      _selectedSubcategories = [];
                      _selectedCategoryId = null;
                      _selectedSubcategoryId = null;
                    }
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.arrow_back, size: 20),
                    SizedBox(width: 6),
                    Text('이전으로', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ),
        if (_selectedCategory == null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              children: categoryIdMap.keys.map((category) {
                final colorIndex = _getCategoryColorIndex(category);
                return GestureDetector(
                  onTap: () => _navigateToSubcategories(category),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.primaries[colorIndex].shade100,
                          Colors.primaries[colorIndex].shade300,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Icon(
                            _getCategoryIcon(category),
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                        Center(
                          child: Text(
                            category,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        if (_selectedCategory != null && !_showFestivalList)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              children: _selectedSubcategories.map((subcategory) {
                final colorIndex = _getCategoryColorIndex(_selectedCategory!);
                final baseColor = Colors.primaries[colorIndex];
                return GestureDetector(
                  onTap: () async {
                    setState(() {
                      _isLoadingSubcategory = true;
                      _categoryFestivalList = [];
                      _selectedSubcategoryId = subcategoryIdMap[subcategory];
                    });
                    await Future.delayed(const Duration(milliseconds: 300));
                    await _sendCategorySelectionToServer(_selectedSubcategoryId!);
                    setState(() {
                      _showFestivalList = true;
                      _isLoadingSubcategory = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          baseColor.shade50,
                          baseColor.shade100,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Icon(
                            _getSubcategoryIcon(subcategory),
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                        Center(
                          child: Text(
                            subcategory,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        if (_isLoadingSubcategory)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (_showFestivalList)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RefreshIndicator(
                onRefresh: () async {
                  if (_selectedSubcategoryId != null) {
                    await _sendCategorySelectionToServer(_selectedSubcategoryId!);
                  }
                },
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 150),
                  itemCount: _categoryFestivalList.length,
                  itemBuilder: (context, index) {
                    final festival = _categoryFestivalList[index];
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
          ),
      ],
    ));
  }
}