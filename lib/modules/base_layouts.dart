import 'package:festivalapp/modules/button_modules.dart';
import 'package:flutter/material.dart';
import 'package:festivalapp/modules/background.dart';

class CurveScreen extends StatelessWidget {
  final Widget title;
  final Widget body;
  final double titleToSubtitleRatio;


  const CurveScreen({
    super.key,
    required this.title,
    required this.body,
    this.titleToSubtitleRatio = 0.02
  });

  @override
  Widget build(BuildContext context) {
    final safeAreaHeight = MediaQuery.of(context).size.height -MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom;
    return Scaffold(
      body : Stack(
        children: [
          const Background(),
          SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: safeAreaHeight * 0.4,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(height:safeAreaHeight*0.2),
                          SizedBox(
                            height: safeAreaHeight*0.2,
                            width: double.infinity,
                            child: ClipPath(
                              clipper: BottomOnlyWhiteClipper(),
                              child: Container(
                                color: Colors.white,
                              )
                            )
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: safeAreaHeight * 0.08,
                          ),
                          title,
                        ],
                      ),
                    ],
                  )
                ),
                Container(
                  height: safeAreaHeight * 0.6,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child : Stack(
                    children: [
                      body,
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}

class BottomOnlyWhiteClipper extends CustomClipper<Path> {
  final double startYRatio; // 시작 위치 비율 (0.0 ~ 1.0)
  final double curvatureRatio; // 곡률 정도 (0.0 ~ 2.0)

  BottomOnlyWhiteClipper({
    this.startYRatio = 0.3,     // 시작 높이
    this.curvatureRatio = 1,  // 곡률
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
  final Widget? floatingActionButton;

  const FlatScreen({
    super.key,
    required this.appBar,
    this.appBarHeight = kToolbarHeight,
    required this.body, 
    this.floatingActionButton,
  });
  
  get selectedIndex => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          leading: null,
          iconTheme: const IconThemeData(color: Colors.white),
          title: appBar,
          centerTitle: appBar is Text || appBar is Column,
        ),
      ),
    body: Stack(
      children: [
        const Background(),
        Padding(
          padding: EdgeInsets.only(
            top: appBarHeight + MediaQuery.of(context).padding.top,
          ),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: body,
            ),
          ),
        ),
      ],
    ),

      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}