import 'package:flutter/material.dart';

class Stander extends StatefulWidget {
  const Stander({super.key});

  @override
  State<Stander> createState() => _StanderState();
}

class _StanderState extends State<Stander> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('这是替身')));
  }
}
