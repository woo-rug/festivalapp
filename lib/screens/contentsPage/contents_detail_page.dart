import 'package:festivalapp/auth/auth_http_client.dart';
import 'package:provider/provider.dart';
import 'package:festivalapp/auth/auth_provider.dart';
import 'package:festivalapp/modules/base_layouts.dart';
import 'package:festivalapp/modules/button_modules.dart';
import 'package:festivalapp/modules/map_modules.dart';
import 'package:festivalapp/modules/title_modules.dart';
import 'package:festivalapp/screens/contentsPage/forum_page.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchContentsDetail(String id, AuthProvider authProvider, BuildContext context) async {
  final url = Uri.parse('http://182.222.119.214:8081/api/contents/$id');
  final client = AuthHttpClient(authProvider, context);
  final request = http.Request('GET', url);
  final streamedResponse = await client.send(request);
  final response = await http.Response.fromStream(streamedResponse);

  print('응답 코드: ${response.statusCode}');
  print('응답 본문: ${response.body}');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final favorite = data['favorite'] ?? false;
    final subCategoryId = data['subCategoryId'] ?? 1;
    // You can return the data as is, since the consumer will extract subCategoryId from the map
    return data;
  } else {
    return {};
  }
}

class ContentsDetailPage extends StatelessWidget {
  final String contentsID;

  const ContentsDetailPage({
    super.key,
    required this.contentsID,
  });

  @override
  Widget build(BuildContext context) {
    return FlatScreen(
      appBar: const Text(
        "상세", // 추후에 id값에 맞는 제목으로 수정해야 함.
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: FutureBuilder<Map<String, dynamic>>(
          future: fetchContentsDetail(contentsID, context.read<AuthProvider>(), context),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 32),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final data = snapshot.data!;
            final contentName = data['contentName'] ?? '';
            final startDate = data['startDateTime']?.substring(0, 10) ?? '';
            final endDate = data['endDateTime']?.substring(0, 10) ?? '';
            final price = data['price'] ?? '';
            final subjectNames = List<String>.from(data['subjectNames'] ?? []);
            final subjectPerformers = subjectNames.map((name) => {'name': name, 'image': 'assets/images/event1.jpg'}).toList();
            final performers = (data['performers'] as List<dynamic>?)
                ?.map((e) => {
                      'name': e['name']?.toString() ?? '',
                      'image': e['image']?.toString() ?? 'assets/images/event1.jpg'
                    })
                .toList() ?? subjectPerformers;
            // Updated siteLinks handling
            final rawSiteLinks = data['siteLinks'];
            List<Map<String, String>> siteLinks = [];
            if (rawSiteLinks is List) {
              siteLinks = rawSiteLinks.map((entry) {
                if (entry is Map<String, dynamic>) {
                  return {
                    'title': entry['title']?.toString() ?? '링크',
                    'url': entry['url']?.toString() ?? ''
                  };
                } else if (entry is String) {
                  return {'title': '링크', 'url': entry};
                } else {
                  return {'title': '링크', 'url': ''};
                }
              }).toList();
            }
            final photoUrls = List<String>.from(data['imageUrls'] ?? []);
            final address = data['address'] ?? '';
            final headerImage = (photoUrls.isNotEmpty) ? photoUrls[0] : '';
            final subject = data['subject'] ?? '';
            final favoriteCount = data['favoriteCount'] ?? 0;
            final favorite = data['favorite'] ?? false;
            final subCategoryId = data['subCategoryId'] ?? 1;
            debugPrint(headerImage);

            return FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchSessions(contentsID, context.read<AuthProvider>(), context),
              builder: (context, sessionSnapshot) {
                final sessionInfo = sessionSnapshot.data ?? [];
                return CustomScrollView(
                  slivers: [
                    _HeaderDelegatePlaceholder(
                      contentName: contentName,
                      startDate: startDate,
                      endDate: endDate,
                      price: price,
                      contentsID: contentsID,
                      headerImage: headerImage,
                      subject: subject,
                      favoriteCount: favoriteCount,
                      isFavorited: favorite,
                      subCategoryId: subCategoryId,
                    ),
                    SliverToBoxAdapter(
                      child: ContentsBody(
                        performers: performers,
                        siteLinks: siteLinks,
                        photoUrls: photoUrls,
                        dailyInfo: sessionInfo,
                        address: address,
                        subject: subject,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _HeaderDelegatePlaceholder extends StatelessWidget {
  final String contentName;
  final String startDate;
  final String endDate;
  final String price;
  final String contentsID;
  final String headerImage;
  final String subject;
  final int favoriteCount;
  final bool isFavorited;
  final int subCategoryId;

  const _HeaderDelegatePlaceholder({
    required this.contentName,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.contentsID,
    required this.headerImage,
    required this.subject,
    required this.favoriteCount,
    required this.isFavorited,
    required this.subCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _HeaderDelegate(
        expandedHeight: 220,
        contentName: contentName,
        startDate: startDate,
        endDate: endDate,
        price: price,
        contentsID: contentsID,
        headerImage: headerImage,
        subject: subject,
        favoriteCount: favoriteCount,
        isFavorited: isFavorited,
        subCategoryId: subCategoryId,
      ),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final String contentName;
  final String startDate;
  final String endDate;
  final String price;
  final String contentsID;
  final String headerImage;
  final String subject;
  final int favoriteCount;
  final bool isFavorited;
  final int subCategoryId;

  _HeaderDelegate({
    required this.expandedHeight,
    required this.contentName,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.contentsID,
    required this.headerImage,
    required this.subject,
    required this.favoriteCount,
    required this.isFavorited,
    required this.subCategoryId,
  });

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
      child: ContentsHeader(
        contentsID: contentsID,
        percent: percent,
        contentName: contentName,
        startDate: startDate,
        endDate: endDate,
        price: price,
        headerImage: headerImage,
        subject: subject,
        favoriteCount: favoriteCount,
        isFavorited: isFavorited,
        subCategoryId: subCategoryId,
      ),
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
  final String contentName;
  final String startDate;
  final String endDate;
  final String price;
  final String headerImage;
  final String subject;
  final int favoriteCount;
  final bool isFavorited;
  final int subCategoryId;

  const ContentsHeader({
    super.key,
    required this.contentsID,
    required this.percent,
    required this.contentName,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.headerImage,
    required this.subject,
    required this.favoriteCount,
    required this.isFavorited,
    required this.subCategoryId,
  });

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
            child: Image.network(
              headerImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
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
                        contentName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        maxLines: percent < 0.3 ? 3 : 2,
                        minFontSize: 10,
                        overflow: TextOverflow.ellipsis,
                        wrapWords: true,
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
                                      startDate,
                                      style: TextStyle(fontSize: 12),
                                    )
                                  ]
                                ),
                                TableRow(
                                  children: [
                                    SizedBox(),
                                    Text(
                                      endDate,
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
                                        price,
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
                      _FavoriteButton(
                        percent: percent,
                        isFavorited: isFavorited,
                        likeCount: favoriteCount,
                        contentsID: contentsID,
                      ),
                      GradientButton(
                        text: "게시판",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ForumPage(category: 2, boardId: subCategoryId),
                            ),
                          );
                        },
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
  final bool isFavorited;
  final int likeCount;
  final String contentsID;
  const _FavoriteButton({
    super.key,
    required this.percent,
    required this.isFavorited,
    required this.likeCount,
    required this.contentsID,
  });

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton> {
  late bool isFavorited;
  late int likeCount;
  double _iconScale = 1.0;
  final Duration _animationDuration = Duration(milliseconds: 100);

  @override
  void initState() {
    super.initState();
    isFavorited = widget.isFavorited;
    likeCount = widget.likeCount;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () async {
            setState(() {
              _iconScale = 1.2;
            });
            Future.delayed(_animationDuration, () {
              if (mounted) {
                setState(() {
                  _iconScale = 1.0;
                });
              }
            });

            final url = Uri.parse('http://182.222.119.214:8081/api/favorites/${widget.contentsID}');
            final authProvider = context.read<AuthProvider>();
            final client = AuthHttpClient(authProvider, context);
            final request = http.Request('POST', url);
            final streamedResponse = await client.send(request);
            final response = await http.Response.fromStream(streamedResponse);

            if (response.statusCode == 200) {
              setState(() {
                isFavorited = !isFavorited;
                likeCount += isFavorited ? 1 : -1;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isFavorited ? '찜 추가되었습니다' : '찜 해제되었습니다'),
                  duration: const Duration(seconds: 2),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('찜 기능 처리 중 오류가 발생했습니다.')),
              );
            }
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
  final String address;
  final String subject;
  const ContentsBody({
    super.key,
    required this.performers,
    this.siteLinks,
    this.photoUrls,
    this.dailyInfo,
    required this.address,
    required this.subject,
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
            MapModules(address: address),

            Container(height: 0, decoration: BoxDecoration(border: Border.all(color: Colors.grey)),),

            Container(width:double.infinity, child: TitleModules.title("상세 정보"),),
            if (performers.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.only(left: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.contains("축구") || subject.contains("야구") || subject.contains("농구")
                          ? "경기 팀"
                          : (subject.contains("음식") || subject.contains("패션") || subject.contains("뷰티") ? "브랜드" : "출연 연예인"),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: performers
                              .map((p) => Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: _PerformerBox(image: p['image']!, name: p['name']!),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Padding(
              padding: EdgeInsets.fromLTRB(18, 16, 18, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "행사 설명",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      subject,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 12, height: 1.5, color: Colors.black87),
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

            if ((dailyInfo?.isNotEmpty ?? false)) ...[
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
              const SizedBox(height: 24),
              ...List.generate(dailyInfo!.length, (index) {
                final info = dailyInfo![index];
                final booths = (info['booths'] as List?)?.map((b) => {'booth': b.toString()}).toList() ?? [];
                final performers = (info['performers'] as List?)
                    ?.map((e) {
                      if (e is Map<String, dynamic>) {
                        return {
                          'name': e['name']?.toString() ?? '',
                          'image': e['image']?.toString() ?? 'assets/images/event1.jpg',
                        };
                      } else if (e is String) {
                        return {
                          'name': e,
                          'image': 'assets/images/event1.jpg',
                        };
                      }
                      return {
                        'name': '',
                        'image': 'assets/images/event1.jpg',
                      };
                    })
                    .cast<Map<String, String>>()
                    .toList()
                    ??
                    (info['artistNames'] as List?)?.map((name) {
                      return {
                        'name': name.toString(),
                        'image': 'assets/images/event1.jpg',
                      };
                    }).cast<Map<String, String>>().toList()
                    ?? [];

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
                                  child: Text("부스 정보", style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            ...booths.map((b) => TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(b['booth'] ?? ''),
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.contains("축구") || subject.contains("야구") || subject.contains("농구")
                          ? "경기 팀"
                          : (subject.contains("음식") || subject.contains("패션") || subject.contains("뷰티") ? "브랜드" : "출연 연예인"),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: performers
                              .map((p) => Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: _PerformerBox(image: p['image']!, name: p['name']!),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
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
          child: Image.network(
            image,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[300],
              width: 70,
              height: 70,
              child: Icon(Icons.broken_image, color: Colors.grey),
            ),
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
// Helper function to fetch sessions
Future<List<Map<String, dynamic>>> fetchSessions(String contentsID, AuthProvider authProvider, BuildContext context) async {
  final sessionsUrl = Uri.parse('http://182.222.119.214:8081/api/contents/$contentsID/sessions');
  final sessionsClient = AuthHttpClient(authProvider, context);
  final sessionsRequest = http.Request('GET', sessionsUrl);
  final sessionsStreamedResponse = await sessionsClient.send(sessionsRequest);
  final sessionsResponse = await http.Response.fromStream(sessionsStreamedResponse);

  print('세션 응답 코드: ${sessionsResponse.statusCode}');
  print('세션 응답 본문: ${sessionsResponse.body}');

  if (sessionsResponse.statusCode == 200) {
    return List<Map<String, dynamic>>.from(jsonDecode(sessionsResponse.body));
  } else {
    return [];
  }
}