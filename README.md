# 轮播图实现

A new Flutter project.

## Getting Started

### 几个关键问题的解决
 1. 轮播图从最后一张图滑动到最后一张图有抽搐现象

  解决办法：不使用PageView(children)形式来写死页面，而是使用PageView.builder来渲染，原理是：Flutter 认为页面是动态生成的，理论上是无限的。滑到任何页面，Flutter 会继续构建。
  同时我还优化了一个小的逻辑问题，让图片从一开始就能左滑，只需要初始化initialPage为1000就好了（比图片总数多）,然后用取余的方式获取列表数组里面的图片链接。

 2. 用户手动滑动时，计时器并未取消，造成两边一起滑动的诡异景象

  解决办法：使用NotificationListener,即通知监听，监听Pageview发生的scroll行为，在用户滑动时取消计时器，停止滑动时再启动计时器即可。

 3. 如果继续使用ViewPage需要面临的问题：
    1. 由于设置的viewportFraction实际上是每个PageView占页面的比例，而scale设置的是每个PageView的缩放比例，那么两张图片之间就会有很宽的间距，这似乎是不换实现方式没办法解决的（未解决）
    2. 如果想要实现层叠方式，使用PageView同样不能实现，因为其并没有z轴
    
 4. 图片有抽搐现象

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
