import 'package:flutter/material.dart';

import 'package:lloud_mobile/views/components/my_avatar.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

class NavBar extends StatelessWidget {
  final Function ontap;
  final int selectedPageIndex;

  NavBar(this.ontap, this.selectedPageIndex);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedPageIndex,
      onTap: this.ontap,
      selectedItemColor: LloudTheme.red,
      unselectedItemColor: LloudTheme.black,
      items: [
        BottomNavigationBarItem(title: Text('Home'), icon: Icon(Icons.home)),
        BottomNavigationBarItem(
            title: Text('Explore'), icon: Icon(Icons.search)),
        BottomNavigationBarItem(title: Text('Shop'), icon: Icon(Icons.store)),
        BottomNavigationBarItem(
            title: Text('Profile'),
            icon: MyAvatar(
              radius: 12,
            )),
      ],
    );
  }
}
