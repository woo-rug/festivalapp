import 'package:festivalapp/modules/base_layouts.dart';
import 'package:festivalapp/modules/button_modules.dart';
import 'package:flutter/material.dart';

class FindIDPWResultPage extends StatelessWidget {
  final bool isID;
  final bool? result;
  final String? id;
  final String? message;

  const FindIDPWResultPage({
    super.key,
    required this.isID,
    this.result,
    this.id,
    this.message,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
