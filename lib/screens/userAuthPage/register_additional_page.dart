import 'dart:convert';
import 'package:festivalapp/modules/title_modules.dart';
import 'package:http/http.dart' as http;
import 'package:festivalapp/screens/userAuthPage/register_result_page.dart';

import '../../modules/base_layouts.dart';
import '../../modules/button_modules.dart';
import 'package:flutter/material.dart';
import 'register_result_page.dart';

class RegisterAdditionalPage extends StatefulWidget {
  const RegisterAdditionalPage({super.key});

  @override
  State<RegisterAdditionalPage> createState() => _RegisterAdditionalPageState();
}

class _RegisterAdditionalPageState extends State<RegisterAdditionalPage> {
  bool isComplete = false;
  final GlobalKey<_AdditionalInfoSectionState> _sectionKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return FlatScreen(
      appBar : AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "회원가입", 
          style: TextStyle( 
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          SizedBox(height: 16),

          TitleModules.title("추가 정보 입력"),

          AdditionalInfoSection(
            key: _sectionKey,
            userName: "홍길동",
            onAnswerComplete: (value) => setState(() => isComplete = value),
          ),
          SizedBox(height: 16), // 위젯 사이 간격 조정, 윗부분에 간격 두는 용도
        ],
      ),
      floatingActionButton: FloatingButton(
        text: "다음 페이지로",
        onPressed: isComplete ? 
        // () async {
        //       final selectedIndexes = _sectionKey.currentState?.selectedIndexes;
        //       final selectedAnswers = _sectionKey.currentState?.questions.asMap().entries.map((entry) {
        //         final qIndex = entry.key;
        //         final q = entry.value;
        //         final selected = selectedIndexes?[qIndex];
        //         return {
        //           'question': q['text'],
        //           'answer': selected != null ? q['options'][selected] : null
        //         };
        //       }).toList();

        //       final response = await http.post(
        //         Uri.parse('https://yourserver.com/submit-answers'),
        //         headers: {'Content-Type': 'application/json'},
        //         body: jsonEncode({'answers': selectedAnswers}),
        //       );

        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (_) => RegisterResult(
        //           //success: response.statusCode == 200
        //         )),
        //       );
        //     }
        () {Navigator.push(context,MaterialPageRoute(builder: (_) => RegisterResult(success:true)));}
          : null,
        isBlue: isComplete ? true : false,
      ),
    );
  }
}


//추가 정보 입력 위젯
class AdditionalInfoSection extends StatefulWidget {
  final String userName;
  final Function(bool) onAnswerComplete;

  const AdditionalInfoSection({
    super.key,
    required this.userName,
    required this.onAnswerComplete,
  });

  @override
  State<AdditionalInfoSection> createState() => _AdditionalInfoSectionState();
}

class _AdditionalInfoSectionState extends State<AdditionalInfoSection> {
  final PageController _pageController = PageController();
  int currentPage = 0;
  List<int?> selectedIndexes = [null, null, null];

  final List<Map<String, dynamic>> questions = [
    {
      "text": "1. 사용자가 가장 선호하는 문화활동을 선택해주세요.",
      "options": ["축제", "콘서트", "뮤지컬",],
    },
    {
      "text": "2. 가장 자주 참여하는 문화활동을 선택해주세요.",
      "options": ["야구 경기", "농구 경기", "배구 경기"],
    },
    {
      "text": "3. 앞으로 참여해보고 싶은 문화활동을 선택해주세요.",
      "options": ["시사회", "강연", "체험 행사"],
    }
  ];

  void _checkCompletion() {
    bool complete = selectedIndexes.every((element) => element != null);
    widget.onAnswerComplete(complete);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: questions.length,
              itemBuilder: (context, pageIndex) {
                final question = questions[pageIndex];
                final options = question["options"] as List<String>;
                return _buildQuestionBlock(
                  question: question["text"] as String,
                  options: options,
                  selectedIndex: selectedIndexes[pageIndex],
                  onSelect: (index) {
                    setState(() {
                      selectedIndexes[pageIndex] = index;
                    });
                    _checkCompletion();
                  },
                );
              },
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (currentPage > 0)
                  GradientButton(
                    text: "이전 질문", 
                    onPressed: () {
                      if (currentPage > 0) {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    }, 
                    isBlue: false,
                    width:120,
                    height: 50,
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionBlock({
    required String question,
    required List<String> options,
    required int? selectedIndex,
    required Function(int) onSelect,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Wrap(
            children: List.generate(options.length, (index) {
              final isSelected = selectedIndex == index;
              return SelectableTag(
                text: options[index],
                isSelected: isSelected,
                onTap: () async {
                  onSelect(index);
                  await Future.delayed(const Duration(milliseconds: 300)); // delay to allow animation to show
                  if (currentPage < questions.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

// 버튼 위젯 (with animated gradient, no scale)
class SelectableTag extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableTag({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = isSelected
        ? const LinearGradient(
            colors: [Color(0xFF64B5F6), Color(0xFF1976D2)],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          )
        : const LinearGradient(
            colors: [Color.fromARGB(255, 230, 230, 230), Color.fromARGB(255, 200, 200, 200)],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 3,
              offset: Offset(1, 1),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
