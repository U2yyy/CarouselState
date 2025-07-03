import 'dart:async';

import 'package:flutter/material.dart';

class NewStander extends StatefulWidget {
  const NewStander({super.key});

  @override
  State<NewStander> createState() => _NewStanderState();
}

class _NewStanderState extends State<NewStander> {
  Timer? _timer;
  int _currentIndex = 0;
  double dragStart = 0.0;
  double dragDis = 0.0;
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
    // TODO: implement initState
    super.initState();
    startAutoScroll();
  }

  void startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      nextImage();
    });
  }

  void stopAutoScroll() {
    _timer?.cancel();
  }

  void nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % imagePaths.length;
    });
  }

  void previousImage() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + imagePaths.length) % imagePaths.length;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<Widget> buildImage(BuildContext context) {
    List<Widget> _stackImages = [];
    Widget? currentImage;
    List<Widget> outerImages = [];
    List<Widget> innerImages = [];
    double scale;
    double leftOffset = 0.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final center = screenWidth / 2;
    final imageWidth = 150.0;
    final imageHeight = 150.0;
    for (int i = 0; i < imagePaths.length; i++) {
      int diff = i - _currentIndex;
      if (diff > imagePaths.length / 2) diff -= imagePaths.length;
      if (diff < -imagePaths.length / 2) diff += imagePaths.length;
      if (diff == 0) {
        scale = 1.0;
        leftOffset = center - imageWidth / 2;
        currentImage = Positioned(
          top: 100,
          left: leftOffset,
          child: AnimatedScale(
            scale: scale,
            duration: Duration(milliseconds: 300),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Container(
                  color: Colors.grey,
                  width: imageWidth,
                  height: imageHeight,
                  child: Image.asset(imagePaths[i], fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        );
      } else if (diff.abs() == 2) {
        scale = 0.6;
        if (diff == 2) {
          leftOffset = center - imageWidth / 2 + imageWidth * diff.abs() * 0.6;
        } else if (diff == -2) {
          leftOffset = center - imageWidth / 2 - imageWidth * diff.abs() * 0.6;
        }
        outerImages.add(
          Positioned(
            top: 100,
            left: leftOffset,
            child: AnimatedScale(
              scale: scale,
              duration: Duration(milliseconds: 300),
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Container(
                    color: Colors.grey,
                    width: imageWidth,
                    height: imageHeight,
                    child: Image.asset(imagePaths[i], fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
        );
      } else if (diff.abs() == 1) {
        scale = 0.8;
        if (diff == 1) {
          leftOffset = center - imageWidth / 2 + imageWidth * diff.abs() * 0.6;
        } else if (diff == -1) {
          leftOffset = center - imageWidth / 2 - imageWidth * diff.abs() * 0.6;
        }
        innerImages.add(
          Positioned(
            top: 100,
            left: leftOffset,
            child: AnimatedScale(
              scale: scale,
              duration: Duration(milliseconds: 300),
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Container(
                    color: Colors.grey,
                    width: imageWidth,
                    height: imageHeight,
                    child: Image.asset(imagePaths[i], fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }
    for (int i = 0; i < outerImages.length; i++) {
      _stackImages.add(outerImages[i]);
    }
    for (int i = 0; i < innerImages.length; i++) {
      _stackImages.add(innerImages[i]);
    }
    if (currentImage != null) {
      _stackImages.add(currentImage);
    }
    return _stackImages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('轮播图主体')),
      body: GestureDetector(
        onHorizontalDragStart: (DragStartDetails details) {
          stopAutoScroll();
          dragStart = details.localPosition.dx;
        },
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          double curLocation = details.localPosition.dx;
          dragDis = curLocation - dragStart;
        },
        onHorizontalDragEnd: (DragEndDetails details) {
          //向左滑时dragDis < 0 因此是向下一张图片滑动 这里很容易想当然搞错
          if (dragDis > 50) {
            previousImage();
          } else if (dragDis < -50) {
            nextImage();
          }
          dragDis = 0.0;
          startAutoScroll();
        },
        child: Stack(children: buildImage(context)),
      ),
    );
  }
}
