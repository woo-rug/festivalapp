import 'dart:async';
import 'package:festivalapp/modules/base_layouts.dart';
import 'package:festivalapp/modules/slider_modules.dart';
import 'package:festivalapp/modules/title_modules.dart';
import 'package:festivalapp/screens/contentsPage/contents_detail_page.dart';
import 'package:festivalapp/screens/contentsPage/forum_page.dart';
import 'package:festivalapp/screens/contentsPage/my_pick_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
            appBarHeight: 75,
            appBar: Row(
              children: [
                Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/cullect_icon_transparent.png',
                      height: 55,
                      width: 55,
                    ),
                  ),
                ),
                SizedBox(width:16),
                _AnimatedTaglineSwitcher()
              ],
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyPickPage()),
                  );
                },
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ForumPage(category: 1,)),
                );},
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
        FutureBuilder<http.Response>(
          future: () async {
            final storage = FlutterSecureStorage();
            final token = await storage.read(key: 'accessToken') ?? '';
            return await http.get(
              Uri.parse('http://182.222.119.214:8081/api/recommend'),
              headers: {
                'Authorization': 'Bearer $token',
              },
            );
          }(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text('추천 정보를 불러오지 못했습니다.'));
            }

            final Map<String, dynamic> responseData = json.decode(snapshot.data!.body);
            final List<dynamic> recommends = responseData['data'] ?? [];
            print('추천 데이터: $recommends');

            if (recommends.length < 6) {
              return const Center(child: Text('추천할 문화생활을 찾고 있어요! 찾기 완료되면 추천해드릴게요.'));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(24, 4, 0, 8),
                  child: const Text(
                    "사용자 기반 추천 문화생활",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                LeftAlignedSnapSlider(
                  items: recommends.sublist(0, 3).map((item) {
                    return RecommandResultButton(
                      imagePath: item['imagePath'],
                      title: item['title'],
                      dateRange: item['dateRange'],
                    );
                  }).toList(),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(24, 36, 0, 8),
                  child: const Text(
                    "비슷한 사용자 기반 추천 문화생활",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                LeftAlignedSnapSlider(
                  items: recommends.sublist(3, 6).map((item) {
                    return RecommandResultButton(
                      imagePath: item['imagePath'],
                      title: item['title'],
                      dateRange: item['dateRange'],
                    );
                  }).toList(),
                ),
              ],
            );
          },
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

class _AnimatedTaglineSwitcher extends StatefulWidget {
  @override
  State<_AnimatedTaglineSwitcher> createState() => _AnimatedTaglineSwitcherState();
}

class _AnimatedTaglineSwitcherState extends State<_AnimatedTaglineSwitcher> {
  int _currentIndex = 0;
  final List<String> _taglines = ['문화를 고르다.', '문화를 모으다.', 'Cullect'];

  @override
  void initState() {
    super.initState();
    _runSequence();
  }

  void _runSequence() async {
    while (mounted) {
      await Future.delayed(Duration(seconds: _currentIndex == 2 ? 8 : 2));
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % _taglines.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: List.generate(_taglines.length, (index) {
          final isCurrent = _currentIndex == index;
          return AnimatedSlide(
            offset: isCurrent ? Offset(0, 0) : Offset(0, 1),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: Visibility(
              visible: isCurrent,
              maintainState: true,
              maintainAnimation: true,
              maintainSize: true,
              child: Text(
                _taglines[index],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}