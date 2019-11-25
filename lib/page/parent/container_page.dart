import 'package:flutter/material.dart';

import '../../config/config.dart';

class ContainerPage extends StatefulWidget {
  @override
  _ContainerPageState createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: BOTTOM_NAVIGATION_DATA.map((item) => item.route).toList(),
        ),
        bottomNavigationBar: createBottomNavigationBar());
  }

  Widget createBottomNavigationBar() {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Color(0xffe9e9e9))), color: Colors.white),
      child: BottomNavigationBar(
        elevation: 0,
        iconSize: 24.0,
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        backgroundColor: Colors.white,
        items: BOTTOM_NAVIGATION_DATA.map((item) {
          return BottomNavigationBarItem(title: Text(item.name), icon: item.icon);
        }).toList(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);
}
