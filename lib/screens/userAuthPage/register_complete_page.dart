import '../../modules/base_layouts.dart';
import '../../modules/button_modules.dart';
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
          //AdditionalInfoSection(userName: "홍길동"),//추가 정보 입력 화면 위젯
          //IdResultBox(userName: "홍길동", userId: "abc123",),//투명 둥근 네모 박스 위젯

          SizedBox(height: 16), // 위젯 사이 간격 조정, 윗부분에 간격 두는 용도

          GradientButton(//각 페이지 위젯 번호 부여하고 수정
            text: "다음 페이지로",
            isBlue: true,
            onPressed: () {
              Navigator.pop(context); // 버튼 사용 예제, 이전 페이지로 이동
            },
          )
        ],
      ),
    );
  }
}

