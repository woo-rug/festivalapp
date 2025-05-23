import 'package:flutter/material.dart';
import 'package:festivalapp/background.dart';

class CurveScreen extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget body;
  final double titleToSubtitleRatio;


  const CurveScreen({
    super.key,
    required this.title,
    this.subtitle,
    required this.body,
    this.titleToSubtitleRatio = 0.04
  });

  @override
  Widget build(BuildContext context) {
      final safeAreaHeight = MediaQuery.of(context).size.height -MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom;
    return Stack(
      children: [
        const Background(),
        SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: safeAreaHeight * 0.2,
                child: Column(
                  children: [
                    Container(
                      height: safeAreaHeight * 0.08,
                    ),
                    title,
                    Container(
                      height: safeAreaHeight * titleToSubtitleRatio,
                    ),
                    if (subtitle != null) subtitle!,
                  ],
                ),
              ),
              SizedBox(
                height: safeAreaHeight * 0.8,
                width: MediaQuery.of(context).size.width,
                child : Stack(
                  children: [
                    ClipPath(
                      clipper: BottomOnlyWhiteClipper(),
                      child: Container(
                        color: Colors.white
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height:safeAreaHeight*0.15, width: MediaQuery.of(context).size.width,),
                        body,
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class BottomOnlyWhiteClipper extends CustomClipper<Path> {
  final double startYRatio; // 시작 위치 비율 (0.0 ~ 1.0)
  final double curvatureRatio; // 곡률 정도 (0.0 ~ 2.0)

  BottomOnlyWhiteClipper({
    this.startYRatio = 0.05,     // 시작 높이: 30%
    this.curvatureRatio = 0.2,  // 곡률: 절반 정도만 휘어짐
  });

  @override
  Path getClip(Size size) {
    final startY = size.height * startYRatio;
    final controlY = size.height * curvatureRatio;

    final path = Path();

    path.moveTo(0, startY);
    path.quadraticBezierTo(
      size.width / 2,
      controlY,
      size.width,
      startY,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}


class FlatScreen extends StatelessWidget {
  final Widget appBar;
  final double appBarHeight;
  final Widget body;
  final Widget? bottomNavigationBar;

  const FlatScreen({
    super.key,
    required this.appBar,
    this.appBarHeight = kToolbarHeight,
    required this.body,
    this.bottomNavigationBar,
  });
  
  get selectedIndex => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar : PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: appBar,
      ),
      body: Stack(
        children: [
          const Background(),
          Positioned(
            top: appBarHeight + MediaQuery.of(context).padding.top,
            child: Container(
              height: bottomNavigationBar != null ? MediaQuery.of(context).size.height - appBarHeight - kBottomNavigationBarHeight : MediaQuery.of(context).size.height - appBarHeight,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.only(
                left: 25,
                right: 25,
              ),
              child: body,
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}