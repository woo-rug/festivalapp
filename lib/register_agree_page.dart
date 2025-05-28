import 'base_layouts.dart';
import 'button_modules.dart';
import 'package:flutter/material.dart';

class RegisterAgreePage extends StatelessWidget {
  const RegisterAgreePage({super.key});

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
          const TermsAgreementSection(),//약관 동의 화면 위젯
          //SignUpFormContent(), //정보 입력 화면 위젯
          //AdditionalInfoSection(userName: "홍길동"),//추가 정보 입력 화면 위젯
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

//약관동의 위젯
class TermsAgreementSection extends StatelessWidget {
  const TermsAgreementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Text(
            "약관 동의",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        TermsItemWidget(
          title: "App 이용 약관",
          content: termsAppContent,
          isRequired: true,
        ),
        TermsItemWidget(
          title: "위치정보 사용 약관",
          content: termsAppContent,
          isRequired: false,
        ),
      ],
    );
  }
}

//약관 박스 위젯
class TermsItemWidget extends StatefulWidget {
  final String title;
  final String content;
  final bool isRequired;

  const TermsItemWidget({
    super.key,
    required this.title,
    required this.content,
    this.isRequired = false,
  });

  @override
  State<TermsItemWidget> createState() => _TermsItemWidgetState();
}

class _TermsItemWidgetState extends State<TermsItemWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          Container(
            height: 160,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              child: Text(
                widget.content,
                style: TextStyle(fontSize: 10),
              ),
            ),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: isChecked,
            onChanged: (val) {
              setState(() {
                isChecked = val ?? false;
              });
            },
            title: Text(
              widget.isRequired ? "(필수) ${widget.title}에 동의합니다." : "(선택) ${widget.title}에 동의합니다.",
              style: TextStyle(fontSize: 10),
              ),
            controlAffinity: ListTileControlAffinity.trailing,
          ),
        ],
      ),
    );
  }
}

//약관 내용 텍스트 (임시)
const String termsAppContent = '''
제 1 조 (목적)
본 약관은 (주)제이피 이노베이션(이하 “회사”라 합니다)이 운영하는 웹사이트 ‘어반런드렛’ (www.urbanlaunderette.com) (이하 “웹사이트”라 합니다)에서 제공하는 온라인 서비스(이하 “서비스”라 한다)를 이용함에 있어 사이버몰과 이용자의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.

제 2 조 (용어의 정의)
본 약관에서 사용하는 용어는 다음과 같이 정의한다.

“웹사이트”란 회사가 재화 또는 용역을 이용자에게 제공하기 위하여 컴퓨터 등 정보통신설비를 이용하여 재화 또는 용역을 거래 할 수 있도록 설정한 가상의 영업장을 말하며, 아울러 사이버몰을 운영하는 사업자의 의미로도 사용합니다.
“이용자”란 “웹사이트”에 접속하여 서비스를 이용하는 회원 및 비회원을 말합니다.
“회원”이라 함은 “웹사이트”에 개인정보를 제공하여 회원등록을 한 자로서, “웹사이트”의 정보를 지속적으로 제공받으며, “웹사이트”이 제공하는 서비스를 계속적으로 이용할 수 있는 자를 말합니다.
“비회원”이라 함은 회원에 가입하지 않고, “웹사이트”이 제공하는 서비스를 이용하는 자를 말합니다.
“ID”라 함은 이용자가 회원가입당시 등록한 사용자 “개인이용문자”를 말합니다.
“멤버십”이라 함은 회원등록을 한 자로서, 별도의 온/오프라인 상에서 추가 서비스를 제공 받을 수 있는 회원을 말합니다.

제 3 조 (약관의 공시 및 효력과 변경)
본 약관은 회원가입 화면에 게시하여 공시하며 회사는 사정변경 및 영업상 중요한 사유가 있을 경우 약관을 변경할 수 있으며 변경된 약관은 공지사항을 통해 공시한다
본 약관 및 차후 회사사정에 따라 변경된 약관은 이용자에게 공시함으로써 효력을 발생한다.

제 4 조 (약관 외 준칙)
본 약관에 명시되지 않은 사항이 전기통신기본법, 전기통신사업법, 정보통신촉진법, ‘전자상거래등에서의 소비자 보호에 관한 법률’, ‘약관의 규제에관한법률’, ‘전자거래기본법’, ‘전자서명법’, ‘정보통신망 이용촉진등에 관한 법률’, ‘소비자보호법’ 등 기타 관계 법령에 규정되어 있을 경우에는 그 규정을 따르도록 한다.

제 2 장 이용계약

제 5 조 (이용신청)
이용신청자가 회원가입 안내에서 본 약관과 개인정보보호정책에 동의하고 등록절차(회사의 소정 양식의 가입 신청서 작성)를 거쳐 ‘확인’ 버튼을 누르면 이용신청을 할 수 있다.
이용신청자는 반드시 실명과 실제 정보를 사용해야 하며 1개의 생년월일에 대하여 1건의 이용신청을 할 수 있다.
실명이나 실제 정보를 입력하지 않은 이용자는 법적인 보호를 받을 수 없으며, 서비스 이용에 제한을 받을 수 있다.

제 6 조 (이용신청의 승낙)
회사는 제5조에 따른 이용신청자에 대하여 제2항 및 제3항의 경우를 예외로 하여 서비스 이용을 승낙한다.
회사는 아래 사항에 해당하는 경우에 그 제한사유가 해소될 때까지 승낙을 유보할 수 있다.
가. 서비스 관련 설비에 여유가 없는 경우
나. 기술상 지장이 있는 경우
다. 기타 회사 사정상 필요하다고 인정되는 경우
회사는 아래 사항에 해당하는 경우에 승낙을 하지 않을 수 있다.
가. 다른 사람의 명의를 사용하여 신청한 경우
나. 이용자 정보를 허위로 기재하여 신청한 경우
다. 사회의 안녕질서 또는 미풍양속을 저해할 목적으로 신청한 경우
라. 기타 회사가 정한 이용신청 요건이 미비한 경우
''';
