import 'package:festivalapp/screens/contentsPage/contents_detail_page.dart';
import 'package:festivalapp/modules/base_layouts.dart';
import 'package:flutter/material.dart';
import 'package:festivalapp/screens/indexPage/keyword_search_view.dart';
import 'package:festivalapp/screens/indexPage/category_search_view.dart';

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
  final PageController _pageController = PageController();
  int _selectedTab = 0;
  int previousTab = 0;
  Map<String, dynamic>? get args => widget.args;

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
      }
      if (args!['contentsID'] != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushNamed('/detail', arguments: args!['contentsID']);
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
              children: const [
                KeywordSearchView(),
                CategorySearchView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
