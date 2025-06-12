import 'package:festivalapp/modules/title_modules.dart';
import 'package:festivalapp/screens/userAuthPage/register_form_page.dart';

import '../../modules/base_layouts.dart';
import '../../modules/button_modules.dart';
import 'package:flutter/material.dart';

class RegisterAgreePage extends StatefulWidget {
  const RegisterAgreePage({super.key});

  @override
  State<RegisterAgreePage> createState() => _RegisterAgreePageState();
}

class _RegisterAgreePageState extends State<RegisterAgreePage> {
  bool isTermsAgreed = false; // 필수 약관 동의 여부

  @override
  Widget build(BuildContext context) {
    return FlatScreen(
      appBar: const Text(
        "회원가입",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          TermsItemWidget(
            title: "App 이용 약관",
            content: termsAppContent,
            isRequired: true,
            isChecked: isTermsAgreed,
            onChanged: (val) {
              setState(() {
                isTermsAgreed = val;
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingButton(
        text: "다음 페이지로",
        onPressed: isTermsAgreed ? () {
                Navigator.push(context, MaterialPageRoute(builder : (context) => RegisterFormPage()));
              }
            : null, // 비활성화
        isBlue: isTermsAgreed ? true : false,
      ),
    );
  }
}


//약관 박스 위젯
class TermsItemWidget extends StatelessWidget {
  final String title;
  final String content;
  final bool isRequired;
  final bool isChecked;
  final ValueChanged<bool> onChanged;

  const TermsItemWidget({
    super.key,
    required this.title,
    required this.content,
    this.isRequired = false,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleModules.title(title),
          const SizedBox(height: 8),
          Container(
            height: 480,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              child: Text(content, style: const TextStyle(fontSize: 10)),
            ),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: isChecked,
            onChanged: (val) => onChanged(val ?? false),
            title: Text(
              isRequired
                  ? "(필수) $title에 동의합니다."
                  : "(선택) $title에 동의합니다.",
              style: const TextStyle(fontSize: 10),
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
본 약관은 Cullect(컬렉트) (이하 “앱"이라 합니다)에서 제공하는 온라인 서비스(이하 “서비스”라 한다)를 이용함에 있어 이용자의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.

제 2 조 (용어의 정의)
본 약관에서 사용하는 용어는 다음과 같이 정의한다.

“앱”란 회사가 재화 또는 용역을 이용자에게 제공하기 위하여 컴퓨터 등 정보통신설비를 이용하여 재화 또는 용역을 거래 할 수 있도록 설정한 가상의 영업장을 말하며, 아울러 사이버몰을 운영하는 사업자의 의미로도 사용합니다.
“이용자”란 “앱”에 접속하여 서비스를 이용하는 회원 및 비회원을 말합니다.
“회원”이라 함은 “앱”에 개인정보를 제공하여 회원등록을 한 자로서, “앱”의 정보를 지속적으로 제공받으며, “앱”이 제공하는 서비스를 계속적으로 이용할 수 있는 자를 말합니다.
“비회원”이라 함은 회원에 가입하지 않고, “앱”이 제공하는 서비스를 이용하는 자를 말합니다.
“ID”라 함은 이용자가 회원가입당시 등록한 사용자 “개인이용문자”를 말합니다.
“멤버십”이라 함은 회원등록을 한 자로서, 별도의 온/오프라인 상에서 추가 서비스를 제공 받을 수 있는 회원을 말합니다.

제 3 조 (약관의 공시 및 효력과 변경)
본 약관은 회원가입 화면에 게시하여 공시하며 회사는 사정변경 및 영업상 중요한 사유가 있을 경우 약관을 변경할 수 있으며 변경된 약관은 공지사항을 통해 공시한다
본 약관 및 차후 회사사정에 따라 변경된 약관은 이용자에게 공시함으로써 효력을 발생한다.

제 4 조 (약관 외 준칙)
본 약관에 명시되지 않은 사항이 전기통신기본법, 전기통신사업법, 정보통신촉진법, ‘전자상거래등에서의 소비자 보호에 관한 법률’, ‘약관의 규제에 관한 법률’, ‘전자거래기본법’, ‘전자서명법’, ‘정보통신망 이용촉진등에 관한 법률’, ‘소비자보호법’ 등 기타 관계 법령에 규정되어 있을 경우에는 그 규정을 따르도록 한다.

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
