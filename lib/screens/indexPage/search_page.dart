import 'package:festivalapp/screens/contentsPage/contents_detail_page.dart';
import 'package:festivalapp/modules/base_layouts.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

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
          builder: (_) => const SearchPageView(),
        );
      },
    );
  }
}

class SearchPageView extends StatefulWidget {
  const SearchPageView({super.key});

  @override
  State<SearchPageView> createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<SearchPageView> {
  List<Map<String, String>> _festivalList = [];

  @override
  void initState() {
    super.initState();
    _fetchFestivals();
  }

  Future<void> _fetchFestivals() async {
    await Future.delayed(Duration(seconds: 1)); // simulate network delay
    setState(() {
      _festivalList = [
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
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedTab == 0 ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '일반 탐색',
                        style: TextStyle(
                          color: _selectedTab == 0 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedTab == 1 ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'AI 추천 문화생활',
                        style: TextStyle(
                          color: _selectedTab == 1 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: _selectedTab == 0
                  ? _buildGeneralExplore()
                  : _buildAIRecommendation(),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildGeneralExplore() {
    return Column(
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
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: '검색어를 입력하세요',
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
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
              child: DropdownButton<String>(
                value: '시작 일자순',
                underline: SizedBox(),
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
                onChanged: (value) {},
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.separated(
            itemCount: _festivalList.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final data = _festivalList[index];
              return ListTile(
                leading: const Icon(Icons.festival),
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
    );
  }

  Widget _buildAIRecommendation() {
    return const Center(
      child: Text("AI 추천 콘텐츠"),
    );
  }
}
