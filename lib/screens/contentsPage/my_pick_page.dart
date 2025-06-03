

import 'package:flutter/material.dart';
import 'package:festivalapp/modules/base_layouts.dart';

class MyPickPage extends StatelessWidget {
  const MyPickPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FlatScreen(
      appBar: const Text(
        '내가 찜한 행사',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5, // 샘플용
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.event),
              title: Text('행사 ${index + 1}'),
              subtitle: const Text('행사 설명이 여기에 들어갑니다.'),
              trailing: const Icon(Icons.favorite, color: Colors.red),
              onTap: () {
                // 상세페이지 이동 등 처리
              },
            ),
          );
        },
      ),
    );
  }
}