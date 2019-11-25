import 'package:flutter/material.dart';

import '../../config/config.dart';
import '../../util/util.dart';
import '../../widget/widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: TAB_BAR_DATA.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[_createTabBar(), _createTabBarView()],
    );
  }

  Widget _createTabBar() {
    return Container(
      constraints: BoxConstraints.expand(height: 50.0),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffe9e9e9))), color: Colors.white),
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: TAB_BAR_DATA.length * 60.0,
            child: TabBar(
              onTap: (index) => _tabBarTapped(index),
              controller: _controller,
              tabs: TAB_BAR_DATA.map((item) {
                return Container(
                  height: 32.0,
                  child: Tab(
                    child: Text('${item.name}'),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _createTabBarView() {
    return Expanded(
        child: NoBehaviorView(
      child: TabBarView(
          controller: _controller,
          children: TAB_BAR_DATA.map((tab) {
            return Container(
              color: Colors.white,
              child: tab.route,
            );
          }).toList()),
    ));
  }

  _tabBarTapped(int index) {
    if (!_controller.indexIsChanging) {
      switch (index) {
        case 0:
          bus.fire(LatestTabTappedEvent());
          break;
        case 1:
          bus.fire(RandomTabTappedEvent());
          break;
        case 2:
          bus.fire(PopularTabTaggedEvent());
          break;
        case 3:
          bus.fire(CategoryTabTappedEvent());
          break;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
