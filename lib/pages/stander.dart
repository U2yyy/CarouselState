import 'dart:async';

import 'package:flutter/material.dart';

class Stander extends StatefulWidget {
  const Stander({super.key});

  @override
  State<Stander> createState() => _StanderState();
}

class _StanderState extends State<Stander> {
  Timer? _timer;
  int _currentPage = 0;
  List<Widget> children = [];
  final PageController _pageController = PageController();
  final List<String> imagePaths = [
    'assets/images/jojo1.jpg',
    'assets/images/jojo2.jpg',
    'assets/images/jojo3.jpg',
    'assets/images/dio.jpg',
    'assets/images/caesar.jpg',
    'assets/images/kars.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('无限轮播图demo')),
      body: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 300),
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            _currentPage = index;
          },
          itemBuilder: (context, index) {
            String path = imagePaths[index % imagePaths.length];
            return Align(
              alignment: Alignment.topCenter,
              child: ClipOval(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset(path, fit: BoxFit.cover),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
