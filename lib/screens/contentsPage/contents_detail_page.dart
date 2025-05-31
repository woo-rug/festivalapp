import 'package:festivalapp/modules/base_layouts.dart';
import 'package:festivalapp/modules/button_modules.dart';
import 'package:festivalapp/modules/map_modules.dart';
import 'package:festivalapp/modules/title_modules.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class ContentsDetailPage extends StatelessWidget {
  final String contentsID;

  const ContentsDetailPage({
    super.key,
    required this.contentsID,
  });

  @override
  Widget build(BuildContext context) {
    return FlatScreen(
      appBar : const Text(
        "상세", // 추후에 id값에 맞는 제목으로 수정해야 함.
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _HeaderDelegate(expandedHeight: 220, contentsID: contentsID),
            ),
            SliverToBoxAdapter(
              child: FutureBuilder<List<Map<String, String>>>(
                future: fetchLinkTitles([
                  "https://example.com",
                  "https://tickets.example.com",
                ]),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Padding(
                      padding: EdgeInsets.only(top: 32),
                      child: CircularProgressIndicator(),
                    ));
                  }
                  return ContentsBody(
                    performers: [
                      {'image': 'assets/images/event1.jpg', 'name': '10CM'},
                      {'image': 'assets/images/event2.jpg', 'name': '싸이'},
                      {'image': 'assets/images/event3.jpg', 'name': '콜드플레이'},
                    ],
                    siteLinks: snapshot.data,
                    photoUrls: [
                      "https://via.placeholder.com/300x200",
                      "https://via.placeholder.com/300x201",
                    ],
                    dailyInfo: [
                      {
                        'booths': [
                          {'location': 'A-1', 'description': '음식 부스'},
                          {'location': 'B-3', 'description': '체험 부스'},
                        ],
                        'performers': [
                          {'image': 'assets/images/event1.jpg', 'name': '10CM'},
                          {'image': 'assets/images/event2.jpg', 'name': '싸이'},
                        ]
                      },
                      {
                        'booths': [
                          {'location': 'C-2', 'description': '굿즈 판매'},
                        ],
                        'performers': [
                          {'image': 'assets/images/event3.jpg', 'name': '콜드플레이'},
                        ]
                      },
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final String contentsID;

  _HeaderDelegate({required this.expandedHeight, required this.contentsID});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double percent = shrinkOffset / expandedHeight;
    final Color borderColor = Color.lerp(Colors.white, Colors.grey, percent.clamp(0.0, 1.0)) ?? Colors.grey;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.all(0),
      child: ContentsHeader(contentsID: contentsID, percent: percent),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => expandedHeight * 0.6;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}

class ContentsHeader extends StatelessWidget {
  final String contentsID;
  final double percent;

  const ContentsHeader({super.key, required this.contentsID, required this.percent});

  @override
  Widget build(BuildContext context) {
    final double scale = (1 - percent * 0.4).clamp(0.82, 1.0);
    final double imageHeight = 200 * scale;
    final double imageWidth = 160 * scale;
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: imageWidth,
            height: imageHeight,
            child: Image.asset(
              'assets/images/event1.jpg',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        contentsID,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        maxLines: 1,
                        minFontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Transform.scale(
                        scale: (1 - (percent * 0.5)).clamp(0.85, 1.0),
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Table(
                              columnWidths: {
                                0 : FixedColumnWidth(30),
                              },
                              children: [
                                TableRow(
                                  children: [
                                    Text(
                                      "기간",
                                      style: TextStyle(color: Colors.grey, fontSize:12),
                                    ),
                                    Text(
                                      "2025.05.27 09:00 ~",
                                      style: TextStyle(fontSize: 12),
                                    )
                                  ]
                                ),
                                TableRow(
                                  children: [
                                    SizedBox(),
                                    Text(
                                      "2025.05.29 23:00",
                                      style: TextStyle(fontSize: 12),
                                    )
                                  ]
                                )
                              ],
                            ),
                            if (percent <= 0.3) Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Table(
                                columnWidths: {
                                  0 : FixedColumnWidth(30),
                                },
                                children: [
                                  TableRow(
                                    children: [
                                      Text(
                                        "가격",
                                        style: TextStyle(color: Colors.grey, fontSize:12),
                                      ),
                                      Text(
                                        "무료 ~ 15,000원",
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ]
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _FavoriteButton(percent: percent),
                      GradientButton(
                        text: "게시판",
                        onPressed: () {},
                        isBlue: true,
                        width: percent > 0.3 ? 110.0 : 125.0,
                        height: percent > 0.3 ? 45.0 : 50.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteButton extends StatefulWidget {
  final double percent;
  const _FavoriteButton({super.key, required this.percent});

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton> {
  bool isFavorited = false;
  int likeCount = 123;
  double _iconScale = 1.0;
  final Duration _animationDuration = Duration(milliseconds: 100);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _iconScale = 1.2;
              isFavorited = !isFavorited;
              likeCount += isFavorited ? 1 : -1;
            });
            Future.delayed(_animationDuration, () {
              if (mounted) {
                setState(() {
                  _iconScale = 1.0;
                });
              }
            });
          },
          child: AnimatedScale(
            scale: _iconScale,
            duration: _animationDuration,
            curve: Curves.easeOut,
            child: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              color: isFavorited
                  ? const Color.fromARGB(255, 230, 78, 67)
                  : Colors.grey,
              size: 28,
            ),
          ),
        ),
        if (widget.percent <= 0.3)
          Text(
            '$likeCount',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
      ],
    );
  }
}

class ContentsBody extends StatelessWidget {
  final List<Map<String, String>> performers;
  final List<Map<String, String>>? siteLinks;
  final List<String>? photoUrls;
  final List<Map<String, dynamic>>? dailyInfo;
  const ContentsBody({
    super.key,
    required this.performers,
    this.siteLinks,
    this.photoUrls,
    this.dailyInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(width:double.infinity, child: TitleModules.title("기본 정보"),),
            MapModules(address: '서울 중구 필동로1길 30',),

            Container(height: 0, decoration: BoxDecoration(border: Border.all(color: Colors.grey)),),

            Container(width:double.infinity, child: TitleModules.title("상세 정보"),),
            Padding(
              padding: const EdgeInsets.only(left: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "출연 연예인",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: performers
                        .map((p) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: _PerformerBox(image: p['image']!, name: p['name']!),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(18, 16, 18, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "행사 설명",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(16)),
                    child: Text(
                      "이번 문화 축제는 다채로운 공연과 볼거리로 가득한 특별한 행사입니다. 국내외 인기 아티스트들의 무대와 다양한 푸드 부스, 체험 행사 등 모든 연령층이 즐길 수 있도록 준비되었습니다. 가족, 친구, 연인과 함께 소중한 추억을 만들어보세요.",
                      style: TextStyle(fontSize: 12, height: 1.5, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),

            if (siteLinks != null && siteLinks!.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 18),
                  child: Text(
                    "관련 링크",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: siteLinks!.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                    child: GradientButton(
                      height: 45,
                      width: double.infinity,
                      text: entry['title']!,
                      onPressed: () async {
                        final url = Uri.parse(entry['url']!);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                      isBlue: true,
                    ),
                  );
                }).toList(),
              ),
            ],

            Column(
              children: [
                SizedBox(height:32),
                Container(height: 0, decoration: BoxDecoration(border: Border.all(color: Colors.grey)),),
                Container(width:double.infinity, child: TitleModules.title("일자별 정보"),),
              ],
            ),

            // 행사 사진 영역
            if (photoUrls != null && photoUrls!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _PhotoCarousel(photoUrls: photoUrls!),
            ],

            // 일차별 상세 정보
            if (dailyInfo != null && dailyInfo!.isNotEmpty) ...[
              const SizedBox(height: 24),
              ...List.generate(dailyInfo!.length, (index) {
                final info = dailyInfo![index];
                final booths = info['booths'] as List<Map<String, String>>;
                final performers = info['performers'] as List<Map<String, String>>;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(color: Colors.grey),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Text(
                              '${index + 1}일차',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Table(
                          border: TableBorder.all(color: Colors.grey.shade300),
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(3),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(color: Colors.grey[200]),
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("위치", style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("부스 정보", style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            ...booths.map((b) => TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(b['location'] ?? ''),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(b['description'] ?? ''),
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: const Text(
                          "출연 연예인",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Row(
                          children: performers
                              .map((p) => Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: _PerformerBox(image: p['image']!, name: p['name']!),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],

            SizedBox(height:120),
          ],
        ),
      ),
    );
  }
}


class _PerformerBox extends StatelessWidget {
  final String image;
  final String name;

  const _PerformerBox({required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            image,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 4),
        Text(
          name,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}



Future<List<Map<String, String>>> fetchLinkTitles(List<String> urls) async {
  final client = http.Client();
  final results = <Map<String, String>>[];

  for (final url in urls) {
    try {
      final response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final html = response.body;
        final titleMatch = RegExp(r'<title>(.*?)</title>', caseSensitive: false).firstMatch(html);
        final title = titleMatch?.group(1)?.trim() ?? "링크";
        results.add({'title': title, 'url': url});
      } else {
        results.add({'title': "링크", 'url': url});
      }
    } catch (_) {
      results.add({'title': "링크", 'url': url});
    }
  }
  client.close();
  return results;
}

class _PhotoCarousel extends StatefulWidget {
  final List<String> photoUrls;
  const _PhotoCarousel({required this.photoUrls});

  @override
  State<_PhotoCarousel> createState() => _PhotoCarouselState();
}

class _PhotoCarouselState extends State<_PhotoCarousel> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.photoUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    widget.photoUrls[index],
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.photoUrls.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index ? Colors.black87 : Colors.grey[400],
              ),
            );
          }),
        ),
      ],
    );
  }
}