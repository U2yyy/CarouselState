import 'package:demo1/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';

void main() {
  // Future.wait([
  //       Future.delayed(Duration(seconds: 2), () {
  //         return "hello";
  //       }),
  //       Future.delayed(Duration(seconds: 4), () {
  //         return "world";
  //       }),
  //     ])
  //     .then((results) {
  //       print(results[0] + results[1]);
  //     })
  //     .catchError((e) {
  //       print(e);
  //     });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'demo1',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BottomNav(),
    );
  }
}
