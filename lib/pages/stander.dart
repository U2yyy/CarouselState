import 'dart:async';

import 'package:flutter/material.dart';

class Stander extends StatefulWidget {
  const Stander({super.key});

  @override
  State<Stander> createState() => _StanderState();
}

class _StanderState extends State<Stander> {
  Timer? _timer;
  int _currentPage = 1000;
  double currentPage = 1000.0;
  List<Widget> children = [];
  final PageController _pageController = PageController(
    viewportFraction: 0.25,
    initialPage: 1000,
  );
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
    // _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
    //   _currentPage++;
    //   _pageController.animateToPage(
    //     _currentPage,
    //     duration: Duration(milliseconds: 300),
    //     curve: Curves.easeInOut,
    //   );
    // });
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page ?? currentPage;
      });
    });
    startAutoScroll();
  }

  void startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void stopAutoScroll() {
    _timer?.cancel();
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
      body: NotificationListener(
        onNotification: (notification) {
          if (notification is ScrollStartNotification) {
            stopAutoScroll();
          } else if (notification is ScrollEndNotification) {
            startAutoScroll();
          }
          return true;
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 300),
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              _currentPage = index;
            },
            itemBuilder: (context, index) {
              double scale = 1.0;
              if (index >= currentPage - 1 && index <= currentPage + 1) {
                scale = scale - (index - currentPage).abs() * 0.3;
              } else {
                scale = 0.5;
              }
              String path = imagePaths[index % imagePaths.length];
              return Align(
                alignment: Alignment.topCenter,
                child: Transform.scale(
                  scale: scale,
                  child: ClipOval(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset(path, fit: BoxFit.cover),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
