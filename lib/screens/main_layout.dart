import 'package:flutter/material.dart';
import 'home_page.dart';
import 'news_feed_page.dart';
import 'profile_page.dart';
import 'package:flutter/cupertino.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  // This allows the list to contain any kind of widget, including both
  // const and non-const StatefulWidgets or StatelessWidgets.
  final List<Widget> _pages = [
    // --- KEY CHANGE: Removed 'const' from HomePage() ---
    // HomePage is now a StatefulWidget and cannot be a const.
    HomePage(),
    NewsFeedPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house),
            activeIcon: Icon(CupertinoIcons.house_fill),
            label: 'Stack',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.news),
            activeIcon: Icon(CupertinoIcons.news_solid),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_crop_circle),
            activeIcon: Icon(CupertinoIcons.person_crop_circle_fill),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
