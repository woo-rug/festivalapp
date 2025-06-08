import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class PageIndexer extends StatefulWidget {
  final List<Widget> pages;

  const PageIndexer({super.key, required this.pages});

  @override
  State<PageIndexer> createState() => _PageIndexerState();
}

class _PageIndexerState extends State<PageIndexer> {
  int _selectedIndex = 0;
  late List<Widget?> _pages;

  @override
  void initState() {
    super.initState();
    _pages = List.filled(widget.pages.length, null);
    _pages[0] = widget.pages[0];
  }

  void _onTap(int index) {
    if (index < widget.pages.length) {
      if (_selectedIndex != index) {
        setState(() {
          _selectedIndex = index;
          _pages[index] ??= widget.pages[index];
        });
      } else {
        // Re-tap on current tab: pop to root
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF1976D2),
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: List.generate(
              _pages.length,
              (index) => _pages[index] ?? const SizedBox.shrink(),
            ),
          ),
          /// 하단 네비게이션 바는 항상 고정
          Positioned(
            left: 32,
            right: 32,
            bottom: Platform.isIOS ? MediaQuery.of(context).padding.bottom : 16,
            child: MediaQuery.removePadding(
              context: context,
              removeBottom: true, // 핵심!
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Container(
                  //height: 72, // 고정 높이로 설정 (SafeArea 길이 포함 안함)
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 243, 243, 243).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: const Color.fromARGB(232, 223, 223, 223),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        offset: const Offset(4, 2),
                        blurRadius: 12,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                    ),
                    child: BottomNavigationBar(
                      currentIndex: _selectedIndex,
                      onTap: _onTap,
                      type: BottomNavigationBarType.fixed,
                      selectedItemColor: const Color(0xFF1976D2),
                      unselectedItemColor: const Color.fromARGB(255, 102, 102, 102),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      showSelectedLabels: true,
                      showUnselectedLabels: false,
                      iconSize: 28,
                      items: [
                        const BottomNavigationBarItem(
                          icon: Icon(CupertinoIcons.home),
                          label: '메인',
                        ),
                        BottomNavigationBarItem(
                          icon: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            width: 56,
                            height: 56,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: _selectedIndex == 1
                                  ? const LinearGradient(
                                      colors: [Color(0xFF64B5F6), Color(0xFF1976D2)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : const LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 245, 245, 245),
                                        Color.fromARGB(255, 182, 182, 182)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                              boxShadow: [
                                BoxShadow(
                                  color: _selectedIndex == 1
                                      ? Colors.blue.shade200
                                      : Colors.grey.shade500,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              CupertinoIcons.sparkles,
                              color: _selectedIndex == 1 ? Colors.white : Colors.grey,
                              size: 24,
                            ),
                          ),
                          label: '',
                        ),
                        const BottomNavigationBarItem(
                          icon: Icon(CupertinoIcons.person),
                          label: '프로필',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
