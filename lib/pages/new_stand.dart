import 'dart:async';

import 'package:flutter/material.dart';

class NewStand extends StatefulWidget {
  const NewStand({super.key});

  @override
  State<NewStand> createState() => _NewStandState();
}

class _NewStandState extends State<NewStand> {
  Timer? _timer;
  int _currentIndex = 0;
  double dragStart = 0.0;
  double dragDis = 0.0;
  double _opacity = 0.0;
  final List<String> standMasterImagePaths = [
    'assets/images/jojo2.jpg',
    'assets/images/jojo3.jpg',
    'assets/images/dio.jpg',
    'assets/images/Avdol.jpg',
    'assets/images/bobo.jpg',
    'assets/images/Noriaki.jpg',
    'assets/images/Yoshikage.jpg',
  ];

  final List<String> standImagePaths = [
    'assets/images/jojo2_stand.jpg',
    'assets/images/jojo3_stand.jpg',
    'assets/images/dio_stand.jpg',
    'assets/images/Avdol_stand.jpg',
    'assets/images/bobo_stand.jpg',
    'assets/images/Noriaki_stand.jpg',
    'assets/images/Yoshikage_stand.jpg',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startAutoScroll();
    _opacity = 1.0;
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
      _opacity = 0.0;
    });

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _currentIndex = (_currentIndex + 1) % standMasterImagePaths.length;
        _opacity = 1.0;
      });
    });
  }

  void previousImage() {
    setState(() {
      _opacity = 0.0;
    });

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _currentIndex =
            (_currentIndex - 1 + standMasterImagePaths.length) %
            standMasterImagePaths.length;
        _opacity = 1.0;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<Widget> buildCarouselImage(BuildContext context) {
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
    for (int i = 0; i < standMasterImagePaths.length; i++) {
      int diff = i - _currentIndex;
      //diff > length / 2 时，反方向更近，减去符合物理逻辑上的关系
      if (diff > standMasterImagePaths.length / 2) {
        diff -= standMasterImagePaths.length;
      }
      if (diff < -standMasterImagePaths.length / 2) {
        diff += standMasterImagePaths.length;
      }
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
                  child: Image.asset(
                    standMasterImagePaths[i],
                    fit: BoxFit.cover,
                  ),
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
                    child: Image.asset(
                      standMasterImagePaths[i],
                      fit: BoxFit.cover,
                    ),
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
                    child: Image.asset(
                      standMasterImagePaths[i],
                      fit: BoxFit.cover,
                    ),
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

  Widget buildBottomImage(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: Duration(milliseconds: 300),
      child: Image.asset(standImagePaths[_currentIndex], fit: BoxFit.cover),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('轮播图主体')),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
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
              child: Stack(children: buildCarouselImage(context)),
            ),
          ),
          Expanded(flex: 3, child: Center(child: buildBottomImage(context))),
        ],
      ),
    );
  }
}
