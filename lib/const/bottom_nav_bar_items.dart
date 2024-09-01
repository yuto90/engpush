import 'package:flutter/material.dart';

class BottomNavBarItems {
  static const items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: '検索',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'ホーム',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: '設定',
    ),
  ];
}
