import 'package:demo1/pages/home_page.dart';
import 'package:demo1/pages/my_file.dart';
import 'package:demo1/pages/stander.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final PageController _controller = PageController(initialPage: 0);
  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: [HomePage(), Stander(), MyFile()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _controller.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          _bottomItem('首页', Icons.home),
          _bottomItem('替身', Icons.people),
          _bottomItem('我的', Icons.account_circle),
        ],
      ),
    );
  }

  _bottomItem(String title, IconData icon) {
    return BottomNavigationBarItem(
      icon: Icon(icon, color: _defaultColor),
      activeIcon: Icon(icon, color: _activeColor),
      label: title,
    );
  }
}
