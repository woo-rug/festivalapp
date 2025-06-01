import 'package:festivalapp/screens/contentsPage/contents_detail_page.dart';
import 'package:festivalapp/modules/base_layouts.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  final Map<String, dynamic>? arguments;

  const SearchPage({super.key, this.arguments});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final String contentsID = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => ContentsDetailPage(contentsID: contentsID),
          );
        }

        return MaterialPageRoute(
          builder: (_) => SearchPageView(args: arguments ?? settings.arguments as Map<String, dynamic>?),
        );
      },
    );
  }
}

class SearchPageView extends StatefulWidget {
  final Map<String, dynamic>? args;

  const SearchPageView({super.key, this.args});

  @override
  State<SearchPageView> createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<SearchPageView> {
  bool _isLoadingSubcategory = false;
  // Access arguments passed from Navigator
  Map<String, dynamic>? get args => widget.args;
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController();
  List<Map<String, String>> _keywordFestivalList = [];
  List<Map<String, String>> _categoryFestivalList = [];
  String? _selectedCategory;
  List<String> _selectedSubcategories = [];
  bool _showFestivalList = false;

  @override
  void initState() {
    super.initState();
    if (args != null) {
      if (args!['tab'] == 0) {
        _selectedTab = 0;
        _pageController.jumpToPage(0);
      } else if (args!['tab'] == 1) {
        _selectedTab = 1;
        _pageController.jumpToPage(1);
        final category = args!['category'];
        final subcategory = args!['subcategory'];
        if (category != null) {
          _navigateToSubcategories(category);
        }
        if (subcategory != null) {
          // simulate a tap on subcategory
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _categoryFestivalList = _getFestivalsForSubcategory(subcategory);
              _showFestivalList = true;
            });
          });
        }
      }
      if (args!['contentsID'] != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushNamed('/detail', arguments: args!['contentsID']);
        });
      }
    }
    _fetchFestivals();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchFestivals() async {
    await Future.delayed(Duration(seconds: 1)); // simulate network delay
    setState(() {
      _keywordFestivalList = [
        {
          "title": "2025 동국대학교 봄 대동제",
          "subtitle": "2025.05.21 - 2025.05.23",
        },
        {
          "title": "2025 연세대학교 봄 대동제",
          "subtitle": "2025.05.24 - 2025.05.26",
        },
        {
          "title": "2025 동국대학교 봄 대동제",
          "subtitle": "2025.05.21 - 2025.05.23",
        },
        {
          "title": "2025 동국대학교 봄 대동제",
          "subtitle": "2025.05.21 - 2025.05.23",
        },
        {
          "title": "2025 동국대학교 봄 대동제",
          "subtitle": "2025.05.21 - 2025.05.23",
        },
        {
          "title": "2025 동국대학교 봄 대동제",
          "subtitle": "2025.05.21 - 2025.05.23",
        },
        {
          "title": "2025 동국대학교 봄 대동제",
          "subtitle": "2025.05.21 - 2025.05.23",
        },
        {
          "title": "2025 동국대학교 봄 대동제",
          "subtitle": "2025.05.21 - 2025.05.23",
        },
        {
          "title": "2025 동국대학교 봄 대동제",
          "subtitle": "2025.05.21 - 2025.05.23",
        },
        {
          "title": "2025 동국대학교 봄 대동제",
          "subtitle": "2025.05.21 - 2025.05.23",
        },
        {
          "title": "2025 동국대학교 봄 대동제",
          "subtitle": "2025.05.21 - 2025.05.23",
        },
        {
          "title": "2025 동국대학교 봄 대동제",
          "subtitle": "2025.05.21 - 2025.05.23",
        },
        {
          "title": "2025 동국대학교 봄 대동제",
          "subtitle": "2025.05.21 - 2025.05.23",
        },
        {
          "title": "2025 동국대학교 봄 대동제",
          "subtitle": "2025.05.21 - 2025.05.23",
        },
      ];
    });
  }

  int _selectedTab = 0;
  int previousTab = 0;

  @override
  Widget build(BuildContext context) {
    return FlatScreen(
      appBar: const Text(
        "탐색",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // 탭 토글
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 48,
                ),
                AnimatedAlign(
                  duration: const Duration(milliseconds: 250),
                  alignment: _selectedTab == 0 ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2 - 24,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF64B5F6), Color(0xFF1976D2)],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          previousTab = _selectedTab;
                          _pageController.animateToPage(
                            0,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          child: Text(
                            '키워드로 탐색',
                            style: TextStyle(
                              color: _selectedTab == 0 ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          previousTab = _selectedTab;
                          _pageController.animateToPage(
                            1,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          child: Text(
                            '카테고리별로 탐색',
                            style: TextStyle(
                              color: _selectedTab == 1 ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _selectedTab = index);
              },
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  child: _buildGeneralExplore(),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  child: _buildCategorySearch(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildGeneralExplore() {
    return SingleChildScrollView(
      child: Column(
        children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: '검색어를 입력하세요',
                    border: InputBorder.none,
                    icon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () { // 검색 취소 알고리즘 추가
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: '시작 일자순',
                isDense: true,
                style: const TextStyle(fontSize: 12, color: Colors.black),
                iconSize: 16,
                items: const [
                  DropdownMenuItem(
                    value: '시작 일자순',
                    child: Text('시작 일자순'),
                  ),
                  DropdownMenuItem(
                    value: '이름순',
                    child: Text('이름순'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Divider(thickness: 1, height: 1),
        ),
        SizedBox(
          height: 500,
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 150),
            itemCount: _keywordFestivalList.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final data = _keywordFestivalList[index];
              return ListTile(
                leading: ClipOval(
                  child: Image.asset(
                    'assets/images/event1.jpg',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(data["title"]!),
                subtitle: Text(data["subtitle"]!),
                onTap: () {
                  Navigator.of(context).pushNamed('/detail', arguments: data["title"]);
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}

  void _navigateToSubcategories(String category) {
    final subcategories = {
      '스포츠': ['축구', '야구', '농구'],
      '공연': ['뮤지컬', '콘서트', '연극'],
      '전시회': ['체험형', '팝 컬처', '회고전'],
      '팝업 스토어': ['패션', '음식', '뷰티'],
      '축제': ['대학 축제', '지역 축제'],
    };

    setState(() {
      _selectedCategory = category;
      _selectedSubcategories = subcategories[category] ?? [];
      _showFestivalList = false;
    });
  }

  Widget _buildCategorySearch() {
    final categories = [
      {'label': '스포츠', 'icon': Icons.sports_soccer, 'colors': [Color(0xFFB0D4E8), Color(0xFF90C3DC)]},
      {'label': '공연', 'icon': Icons.music_note, 'colors': [Color(0xFFF6E7A8), Color(0xFFEED97C)]},
      {'label': '전시회', 'icon': Icons.palette, 'colors': [Color(0xFFF5CFC3), Color(0xFFEFAE95)]},
      {'label': '팝업 스토어', 'icon': Icons.storefront, 'colors': [Color(0xFFE0D6EF), Color(0xFFCEC1E2)]},
      {'label': '축제', 'icon': Icons.celebration, 'colors': [Color(0xFFCEE7CB), Color(0xFFB6D7B3)]},
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selectedCategory != null)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  if (_showFestivalList) {
                    setState(() {
                      _showFestivalList = false;
                    });
                  } else {
                    setState(() {
                      _selectedCategory = null;
                    });
                  }
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text("이전으로 돌아가기"),
              ),
            ),
          _selectedCategory == null
              ? GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 32),
                  children: categories.map((category) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: category['colors'] as List<Color>,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          await Future.delayed(Duration(milliseconds: 50));
                          setState(() {
                            _navigateToSubcategories(category['label'] as String);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(16),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Icon(
                                category['icon'] as IconData,
                                size: 80,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                            Center(
                              child: Text(
                                category['label'] as String,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                )
                  : _isLoadingSubcategory
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 48),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : _showFestivalList
                          ? ListView.separated(
                              padding: const EdgeInsets.only(bottom: 150),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _categoryFestivalList.length,
                              separatorBuilder: (context, index) => const Divider(),
                              itemBuilder: (context, index) {
                                final data = _categoryFestivalList[index];
                                return ListTile(
                                  leading: ClipOval(
                                    child: Image.asset(
                                      'assets/images/event1.jpg',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(data["title"]!),
                                  subtitle: Text(data["subtitle"]!),
                                  onTap: () {
                                    Navigator.of(context).pushNamed('/detail', arguments: data["title"]);
                                  },
                                );
                              },
                            )
                          : GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.2,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: _selectedSubcategories.map((item) {
                                final lightColors = {
                                  '스포츠': [Color(0xFFD9EAF4), Color(0xFFC6DFEF)],
                                  '공연': [Color(0xFFFBF4D0), Color(0xFFF7E9A9)],
                                  '전시회': [Color(0xFFFBE3DD), Color(0xFFF6CDBC)],
                                  '팝업 스토어': [Color(0xFFF0EBF8), Color(0xFFE6DEF1)],
                                  '축제': [Color(0xFFE4F3E2), Color(0xFFD3EAD1)],
                                };
                                final colors = lightColors[_selectedCategory] ?? [Colors.grey[300]!, Colors.grey[200]!];

                                return GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      _isLoadingSubcategory = true;
                                      _categoryFestivalList = [];
                                    });
                                    await Future.delayed(Duration(milliseconds: 300));
                                    setState(() {
                                      _categoryFestivalList = _getFestivalsForSubcategory(item);
                                      _showFestivalList = true;
                                      _isLoadingSubcategory = false;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: colors,
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        item,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
        ],
      ),
    );
  }
}

  List<Map<String, String>> _getFestivalsForSubcategory(String subcategory) {
    return List.generate(
      5,
      (index) => {
        "title": "$subcategory 행사 ${index + 1}",
        "subtitle": "2025.07.${(index + 10)} - 2025.07.${(index + 12)}",
      },
    );
  }