import 'dart:async';
import 'package:festivalapp/screens/contentsPage/contents_detail_page.dart';
import 'package:flutter/material.dart';




// 페이지뷰 슬라이더 -> AI 추천
class LeftAlignedSnapSlider extends StatefulWidget {
  final List<Widget> items;

  const LeftAlignedSnapSlider({super.key, required this.items});

  @override
  State<LeftAlignedSnapSlider> createState() => _LeftAlignedSnapSliderState();
}

class _LeftAlignedSnapSliderState extends State<LeftAlignedSnapSlider> {
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;

  final double itemWidth = 160; // 카드 하나의 폭
  final double spacing = 12;    // 카드 간 간격

  void _onScroll() {
    final position = _scrollController.offset;
    final singleItemExtent = itemWidth + spacing;
    final index = (position / singleItemExtent).round();
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.items.length, (index) {
        final isActive = index == _currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 10 : 6,
          height: isActive ? 10 : 6,
          decoration: BoxDecoration(
            color: isActive ? Colors.black : Colors.grey,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const PageScrollPhysics(), // 스냅 효과
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              return Container(
                width: itemWidth,
                margin: EdgeInsets.only(
                  left: index == 0 ? 16 : spacing,
                  right: index == widget.items.length - 1 ? 16 : 0,
                ),
                child: widget.items[index],
              );
            },
          ),
        ),
        const SizedBox(height: 4),
        _buildDotsIndicator(),
      ],
    );
  }
}


// AI추천 버튼
class RecommandResultButton extends StatelessWidget {
  final String imagePath;
  final String title;
  final String dateRange;

  const RecommandResultButton({
    super.key,
    required this.imagePath,
    required this.title,
    required this.dateRange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 150,
              child: Image.network(
                imagePath,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
              ),
            )
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 8, left:8, right: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 4, left:8, right: 8),
            child: Text(
              dateRange,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
