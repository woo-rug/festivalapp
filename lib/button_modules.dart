import 'package:flutter/material.dart';

class CardSliderWithStaticDots extends StatefulWidget {
  const CardSliderWithStaticDots({super.key});

  @override
  State<CardSliderWithStaticDots> createState() => _CardSliderWithStaticDotsState();
}

class _CardSliderWithStaticDotsState extends State<CardSliderWithStaticDots> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> items = [
    {'image': 'assets/images/event1.jpg', 'text': '행사 1'},
    {'image': 'assets/images/event2.jpg', 'text': '행사 2'},
    {'image': 'assets/images/event3.jpg', 'text': '행사 3'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 이미지 카드 슬라이더
        SizedBox(
          height: 200,
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

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        item['image']!,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        color: Colors.black.withOpacity(0.3),
                      ),
                      Center(
                        child: Text(
                          item['text']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
              width: 6,
              height: 6,
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
    );
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF64B5F6), Color(0xFF1976D2)],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
