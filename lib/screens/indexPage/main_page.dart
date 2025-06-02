import 'dart:async';
import 'package:festivalapp/modules/base_layouts.dart';
import 'package:festivalapp/modules/slider_modules.dart';
import 'package:festivalapp/modules/title_modules.dart';
import 'package:festivalapp/screens/contentsPage/contents_detail_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        if (settings.name == '/contents_detail') {
          final String contentsID = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => ContentsDetailPage(contentsID: contentsID),
          );
        }
        return MaterialPageRoute(
          builder: (_) => FlatScreen(
            appBarHeight: 80,
            appBar: Container(
              height: 60,
              width: 60,
              color: Colors.grey,
              child: Center(
                child: Text(
                  "아이콘",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w100,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            body: _MainPageBody(),
          ),
        );
      },
    );
  }
}

class _MainPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(height: 24),
        CardSliderWithStaticDots(
          height: 250,
          width: 400,
        ),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 90,
                  margin: EdgeInsets.only(left: 24, right: 12, top: 16, bottom: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Color.fromARGB(255, 239, 177, 183), Color.fromARGB(255, 250, 126, 126)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.favorite, color: Colors.grey[700], size: 24),
                      SizedBox(height: 8),
                      Text(
                        "찜한 행사",
                        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 90,
                  margin: EdgeInsets.only(right: 24, left: 12, top: 16, bottom: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Color(0xFFC8E6C9), Color.fromARGB(255, 147, 227, 151)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.edit, color: Colors.grey[700], size: 24),
                      SizedBox(height: 8),
                      Text(
                        "내가 쓴 글",
                        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        TitleModules.title("AI가 추천하는 문화생활"),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(alignment:Alignment.centerLeft, padding: EdgeInsets.fromLTRB(24, 4, 0, 8), child: Text("사용자 기반 추천 문화생활", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),),
            LeftAlignedSnapSlider(
              items: [
                RecommandResultButton(
                  imagePath: 'assets/images/ai_recommend1.jpg',
                  title: 'AI 추천 문화생활 1',
                  dateRange: '2025.01.01 ~ 01.10',
                ),
                RecommandResultButton(
                  imagePath: 'assets/images/ai_recommend2.jpg',
                  title: 'AI 추천 문화생활 2',
                  dateRange: '2025.01.01 ~ 01.10',
                ),
                RecommandResultButton(
                  imagePath: 'assets/images/ai_recommend3.jpg',
                  title: 'AI 추천 문화생활 3',
                  dateRange: '2025.01.01 ~ 01.10',
                ),
              ],
            ),

            Container(alignment:Alignment.centerLeft, padding: EdgeInsets.fromLTRB(24, 36, 0, 8), child: Text("비슷한 사용자 기반 추천 문화생활", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),),
            LeftAlignedSnapSlider(
              items: [
                RecommandResultButton(
                  imagePath: 'assets/images/ai_recommend1.jpg',
                  title: 'AI 추천 문화생활 1',
                  dateRange: '2025.01.01 ~ 01.10',
                ),
                RecommandResultButton(
                  imagePath: 'assets/images/ai_recommend2.jpg',
                  title: 'AI 추천 문화생활 2',
                  dateRange: '2025.01.01 ~ 01.10',
                ),
                RecommandResultButton(
                  imagePath: 'assets/images/ai_recommend3.jpg',
                  title: 'AI 추천 문화생활 3',
                  dateRange: '2025.01.01 ~ 01.10',
                ),
              ],
            ),
          ],
        ),
        SizedBox(height:120),
      ],
    );
  }
}

class CardSliderWithStaticDots extends StatefulWidget {
  final double height;
  final double width;

  const CardSliderWithStaticDots({
    super.key,
    this.height = 200,
    this.width = double.infinity,
  });

  @override
  State<CardSliderWithStaticDots> createState() => _CardSliderWithStaticDotsState();
}

class _CardSliderWithStaticDotsState extends State<CardSliderWithStaticDots> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  Timer? _autoSlideTimer;

  final List<Map<String, String>> items = [
    {'image': 'assets/images/event1.jpg', 'title': '드디어 시작된 대학축제!', 'subtitle': '다양한 대학 축제들을 확인해보세요.'},
    {'image': 'assets/images/event2.jpg', 'title': '날씨 좋은데...', 'subtitle': '야구장 가서 경기보는건 어때요?'},
    {'image': 'assets/images/event3.jpg', 'title': '이런 연극은 어때요?', 'subtitle': '영화보다 재밌을지도 몰라요!'},
  ];

  @override
  void initState() {
    super.initState();
    _autoSlideTimer = Timer.periodic(Duration(seconds: 4), (Timer timer) {
      if (_controller.hasClients) {
        int nextPage = (_currentPage + 1) % items.length;
        _controller.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentPage = nextPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 이미지 카드 슬라이더
          SizedBox(
            height: widget.height,
            width: widget.width,
            child: PageView.builder(
              controller: _controller,
              itemCount: items.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final item = items[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/contents_detail',
                      arguments: items[index]['title']!,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: widget.width,
                      height: widget.height,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            Image.asset(
                              item['image']!,
                              fit: BoxFit.cover,
                              width: widget.width,
                              height: widget.height,
                            ),
                            Container(
                              width: widget.width,
                              height: widget.height,
                              color: Colors.black.withOpacity(0.3),
                            ),
                            Positioned(
                              bottom: 16,
                              left: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item['subtitle']!,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 209, 209, 209),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // 고정된 dot 인디케이터 (슬라이더 바깥)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(items.length, (dotIndex) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentPage == dotIndex ? 10 : 6,
                height: _currentPage == dotIndex ? 10 : 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == dotIndex
                      ? Colors.black87
                      : Colors.black26,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}