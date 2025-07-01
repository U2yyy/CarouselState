# 轮播图实现

A new Flutter project.

## Getting Started

### 几个关键问题的解决
1. 轮播图从最后一张图滑动到最后一张图有抽搐现象

  解决办法：不使用PageView(children)形式来写死页面，而是使用PageView.builder来渲染，原理是：Flutter 认为页面是动态生成的，理论上是无限的。滑到任何页面，Flutter 会继续构建。
  同时我还优化了一个小的逻辑问题，让图片从一开始就能左滑，只需要初始化initialPage为1000就好了（比图片总数多）,然后用取余的方式获取列表数组里面的图片链接。

2. 用户手动滑动时，计时器并未取消，造成两边一起滑动的诡异景象

  解决办法：使用NotificationListener,即通知监听，监听Pageview发生的scroll行为，在用户滑动时取消计时器，停止滑动时再启动计时器即可。

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
