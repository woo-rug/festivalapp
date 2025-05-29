import 'package:flutter/material.dart';

class Background extends StatelessWidget {

  const Background({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.bottom,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF1976D2), // 파란색
            Color(0xFF64B5F6),
          ],
        ),
      )
    );
  }
}