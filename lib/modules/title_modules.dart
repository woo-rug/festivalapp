import 'package:flutter/material.dart';

class TitleModules {
  static Widget title(String text, {double fontSize = 24, Color? color}) {
    return Container(
      padding: const EdgeInsets.only(top: 25, bottom: 15, left:30),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: color ?? Colors.black,
        ),
      )
    );
  }

  static Widget subtitle(String text, {double fontSize = 16, Color? color}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: color ?? Colors.black,
      ),
    );
  }
}