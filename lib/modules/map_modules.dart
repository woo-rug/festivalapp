import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MapModules extends StatefulWidget {
  final String address;
  final double height;
  final double width;

  const MapModules({
    super.key, 
    required this.address,
    this.height = 350,
    this.width = 350,
  });

  @override
  State<MapModules> createState() => _MapModulesState();
}

class _MapModulesState extends State<MapModules> {
  late WebViewController controller;
  double? lat;
  double? lng;
  bool isPageLoaded = false;

  void _maybeRunJS() {
    if (isPageLoaded && lat != null && lng != null) {
      try {
        controller.runJavaScript('loadAddress($lat, $lng)');
      } catch (e) {
        debugPrint('❌ JavaScript execution failed: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    controller = WebViewController();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            debugPrint('lat : $lat, lng : $lng');
          },
          onPageFinished: (url) {
            isPageLoaded = true;
            _maybeRunJS();
          },
        ),
      )
      ..loadFlutterAsset('assets/map.html');
    _fetchCoordinates();
  }

  Future<void> _fetchCoordinates() async {
    final url = Uri.parse(
        'https://dapi.kakao.com/v2/local/search/address.json?query=${Uri.encodeComponent(widget.address)}');
    final response = await http.get(
      url,
      headers: {'Authorization': 'KakaoAK d61e078952efa1d181763445c7233eae'},
    );
    debugPrint('지도 주소 : ${widget.address}');
    debugPrint('지도 응답 바디: ${response.body}');
    debugPrint('지도 응답 헤더: ${response.headers}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['documents'] != null && data['documents'].isNotEmpty) {
        final location = data['documents'][0]['address'];
        final double? latitude = double.tryParse(location['y']);
        final double? longitude = double.tryParse(location['x']);
        if (latitude != null && longitude != null) {
          setState(() {
            lat = latitude;
            lng = longitude;
          });
          _maybeRunJS();
        }
      }
    } else {
      debugPrint('Failed to fetch coordinates: ${response.statusCode}');
    }
  }

  void _openKakaoMap() async {
    if (lat != null && lng != null) {
      final url =
          'https://map.kakao.com/link/to/${Uri.encodeComponent(widget.address)},$lat,$lng';
      final uri = Uri.parse(url);
      final success = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!success) {
        debugPrint('Could not launch Kakao Map');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color:Colors.grey)
          ),
          height: widget.height,
          width: widget.width,
          child: WebViewWidget(
            controller: controller,
          ),
        ),
        SizedBox(height:16),
        Padding(
          padding: EdgeInsets.only(left:12),
          child : Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: {
              0 : FixedColumnWidth(35),
            },
            children: [
              TableRow(
                children: [
                  Text(
                    "위치",
                    style: TextStyle(color: Colors.grey, fontSize:14),
                  ),
                  Text(
                    widget.address,
                    style: TextStyle(fontSize: 14),
                  ),
                  TextButton(
                    onPressed: (lat != null && lng != null) ? _openKakaoMap : null,
                    child: Text("가는 길 찾기"),
                  )
                ]
              ),
            ],
          ),
        ),
      ],
    );
  }
}