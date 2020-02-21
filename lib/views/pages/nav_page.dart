import 'package:flutter/material.dart';

import '../pages/songs_page.dart';
import '../_common/nav_bar.dart';

class NavPage extends StatefulWidget {
  @override
  _NavPageState createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  final List<Widget> _pages = [
    SongsPage(),
    // PortfolioPage(),
    // StorePage(),
    // ListenerAccountPage(),
  ];
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Holla'),
      ),
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: NavBar(_selectPage),
    );
  }
}
