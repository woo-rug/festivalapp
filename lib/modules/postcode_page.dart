import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PostcodePage extends StatelessWidget {
  final Function(String fullAddress) onAddressSelected;

  const PostcodePage({super.key, required this.onAddressSelected});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString('''
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="utf-8">
          <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
        </head>
        <body>
          <div id="layer" style="width:100%;height:100%;"></div>
          <script>
            new daum.Postcode({
              oncomplete: function(data) {
                var fullAddr = data.address;
                window.flutter_inappwebview.callHandler('onSelect', fullAddr);
              }
            }).open();
          </script>
        </body>
        </html>
      ''');

    return Scaffold(
      appBar: AppBar(title: const Text("주소 검색")),
      body: WebViewWidget(
        controller: controller
          ..addJavaScriptChannel(
            'flutter_inappwebview',
            onMessageReceived: (msg) {
              onAddressSelected(msg.message);
              Navigator.pop(context);
            },
          ),
      ),
    );
  }
}

