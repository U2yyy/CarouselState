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
    //定时轮播
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
      //diff > length / 2 时，反方向更近，减去符合物理逻辑上的关系
      if (diff > imagePaths.length / 2) diff -= imagePaths.length;
      if (diff < -imagePaths.length / 2) diff += imagePaths.length;
      //最上面的图片最后加，我们先保留
      if (diff == 0) {
        scale = 1.0;
        leftOffset = center - imageWidth / 2;
        currentImage = AnimatedPositioned(
          duration: Duration(milliseconds: 300),
          key: ValueKey('image$i'),
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
        //最外围的图片有两张，先找到，然后存到Widget列表里面
        scale = 0.6;
        if (diff == 2) {
          leftOffset = center - imageWidth / 2 + imageWidth * diff.abs() * 0.6;
        } else if (diff == -2) {
          leftOffset = center - imageWidth / 2 - imageWidth * diff.abs() * 0.6;
        }
        outerImages.add(
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            key: ValueKey('image$i'),
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
        //靠近最上面图片的有两张，找到后先存在Widget列表里面
        scale = 0.8;
        if (diff == 1) {
          leftOffset = center - imageWidth / 2 + imageWidth * diff.abs() * 0.6;
        } else if (diff == -1) {
          leftOffset = center - imageWidth / 2 - imageWidth * diff.abs() * 0.6;
        }
        innerImages.add(
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            key: ValueKey('image$i'),
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
    //先加最外层，再加靠内层，最后加最上层的图片，顺序很重要
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
        //每次_currentIndex改变时都会调用setState()重新渲染
        child: Stack(children: buildImage(context)),
      ),
    );
  }
}
