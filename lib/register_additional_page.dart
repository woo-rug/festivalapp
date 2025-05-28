import 'base_layouts.dart';
import 'button_modules.dart';
import 'package:flutter/material.dart';

class ExampleFlat extends StatelessWidget {
  const ExampleFlat({super.key});

  @override
  Widget build(BuildContext context) {
    return FlatScreen( // base_layouts.dart에서 정의된 FlatScreen 위젯 사용
      appBarHeight: 80, // 앱바 높이, 따로 설정할 필요 없다면 삭제하시면 됩니다!
      appBar : AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // 앱바의 아이콘 색상, 변경 안하셔도 됩니다.
        ),
        title: Text(
          "회원가입", // 여기 부분만 페이지에 맞게 수정하시면 됩니다!
          style: TextStyle( // 굳이 건드릴 필요 없을 것 같습니다!
            fontSize: 18, // 앱바의 글자 크기
            fontWeight: FontWeight.w700, // 앱바의 글자 두께
            color: Colors.white, // 앱바의 글자 색상
          ),
        ),
        centerTitle: true, // 앱바 글자 중앙 정렬
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          //필요하신 위젯을 여기에 추가하시면 됩니다! ListView 아니어도 괜찮고 편하신 모듈로 사용하시면 되는데,
          // ListView가 스크롤이 가능해서 이걸 중심으로 사용하시는 것을 추천드리긴 합니다.

          SizedBox(height: 16), // 위젯 사이 간격 조정, 윗부분에 간격 두는 용도

          //const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0),child: SelectableTabRow(),), //한 라인 두 버튼 위젯
          //const ScrollableTextList(),//그냥 테스트용 의미없음
          //const TermsAgreementSection(),//약관 동의 화면 위젯
          //SignUpFormContent(), //정보 입력 화면 위젯
          AdditionalInfoSection(userName: "홍길동"),//추가 정보 입력 화면 위젯
          //IdResultBox(userName: "홍길동", userId: "abc123",),//투명 둥근 네모 박스 위젯

          SizedBox(height: 16), // 위젯 사이 간격 조정, 윗부분에 간격 두는 용도

          GradientButton(//각 페이지 위젯 번호 부여하고 수정
            text: "다음 페이지로",
            onPressed: () {
              Navigator.pop(context); // 버튼 사용 예제, 이전 페이지로 이동
            },
          )
        ],
      ),
    );
  }
}


//추가 정보 입력 위젯
class AdditionalInfoSection extends StatelessWidget {
  final String userName;

  const AdditionalInfoSection({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Text(
            "추가 정보 입력",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        // 질문 문구
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
          child: Text(
            "2. ${userName}님이 관심있어 하는 문화생활을 모두 선택해주세요.",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // 선택 버튼들 (Wrap으로 감싸기)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Wrap(
            children: const [
              SelectableTag(text: "축제"),
              SelectableTag(text: "콘서트"),
              SelectableTag(text: "뮤지컬"),
              SelectableTag(text: "야구 경기"),
              SelectableTag(text: "시사회"),
            ],
          ),
        ),
      ],
    );
  }
}

//버튼 위젯
class SelectableTag extends StatefulWidget {
  final String text;

  const SelectableTag({super.key, required this.text});

  @override
  State<SelectableTag> createState() => _SelectableTagState();
}

class _SelectableTagState extends State<SelectableTag> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected ? const Color(0xFF487FFF) : Colors.grey.shade300;
    final textColor = isSelected ? Colors.white : Colors.black87;

    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
