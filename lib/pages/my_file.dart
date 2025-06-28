import 'package:flutter/material.dart';

class MyFile extends StatefulWidget {
  const MyFile({super.key});

  @override
  State<MyFile> createState() => _MyFileState();
}

class _MyFileState extends State<MyFile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('这是个人档案')));
  }
}
