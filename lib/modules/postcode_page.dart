import 'package:daum_postcode_search/widget.dart';
import 'package:festivalapp/modules/base_layouts.dart';
import 'package:flutter/material.dart';

class PostcodePage extends StatefulWidget {
  @override
  _PostcodePageState createState() => _PostcodePageState();
}

class _PostcodePageState extends State<PostcodePage> {
  bool _isError = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    DaumPostcodeSearch daumPostcodeSearch = DaumPostcodeSearch(
      
      onConsoleMessage: (_, message) => print(message),
      onReceivedError: (controller, request, error) => setState(
        () {
          _isError = true;
          errorMessage = error.description;
        },
      ),
    );

    return FlatScreen(
      appBar: const Text(
        "주소 검색",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height:16),
            Expanded(
              child: daumPostcodeSearch,
            ),
            if (_isError)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      errorMessage ?? "알 수 없는 오류가 발생했습니다.",
                      style: TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      child: const Text("다시 시도"),
                      onPressed: () {
                        daumPostcodeSearch.controller?.reload();
                        setState(() {
                          _isError = false;
                          errorMessage = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}