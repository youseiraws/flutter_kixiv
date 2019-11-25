import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../page/page.dart';
import 'colors.dart';
import 'strings.dart';
import 'values.dart';

export 'colors.dart';
export 'strings.dart';
export 'values.dart';

final ThemeData DEFAULT_THEME = ThemeData(primarySwatch: PRIMARY_COLORS);

final ThemeData GLOBAL_THEME = DEFAULT_THEME.copyWith(
    backgroundColor: BACKGROUND_COLOR,
    splashColor: SPLASH_COLOR,
    highlightColor: HIGHLIGHT_COLOR,
    textTheme: DEFAULT_THEME.textTheme.copyWith(
      display1: DEFAULT_THEME.textTheme.display1.copyWith(fontFamily: DEFAULT_FONT),
      display2: DEFAULT_THEME.textTheme.display2.copyWith(fontFamily: DEFAULT_FONT),
      display3: DEFAULT_THEME.textTheme.display3.copyWith(fontFamily: DEFAULT_FONT),
      display4: DEFAULT_THEME.textTheme.display4.copyWith(fontFamily: DEFAULT_FONT),
      headline: DEFAULT_THEME.textTheme.headline.copyWith(fontFamily: DEFAULT_FONT),
      title: DEFAULT_THEME.textTheme.title.copyWith(fontFamily: DEFAULT_FONT),
      subhead: DEFAULT_THEME.textTheme.subhead.copyWith(fontFamily: DEFAULT_FONT),
      body1: DEFAULT_THEME.textTheme.body1.copyWith(fontFamily: DEFAULT_FONT),
      body2: DEFAULT_THEME.textTheme.body2.copyWith(fontFamily: DEFAULT_FONT),
      caption: DEFAULT_THEME.textTheme.caption.copyWith(fontFamily: DEFAULT_FONT),
      button: DEFAULT_THEME.textTheme.button.copyWith(fontFamily: DEFAULT_FONT),
    ),
    iconTheme: DEFAULT_THEME.iconTheme.copyWith(color: DEFAULT_THEME.primaryColor),
    chipTheme: DEFAULT_THEME.chipTheme.copyWith(
        labelStyle: DEFAULT_THEME.chipTheme.labelStyle.copyWith(fontFamily: DEFAULT_FONT, color: LABEL_COLOR),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        deleteIconColor: DEFAULT_THEME.primaryColor),
    tabBarTheme: DEFAULT_THEME.tabBarTheme.copyWith(
        indicator: BoxDecoration(color: DEFAULT_THEME.primaryColor, borderRadius: BorderRadius.circular(4.0)),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: LABEL_COLOR,
        labelStyle: TextStyle(fontFamily: DEFAULT_FONT),
        unselectedLabelColor: UNSELECTED_LABEL_COLOR,
        unselectedLabelStyle: TextStyle(fontFamily: DEFAULT_FONT)));

final List<_Item> BOTTOM_NAVIGATION_DATA = <_Item>[
  _Item(name: '首页', icon: Icon(Feather.getIconData('home'), size: 20.0), route: HomePage()),
  _Item(name: '下载', icon: Icon(Feather.getIconData('download'), size: 20.0), route: DownloadPage()),
  _Item(name: '我的', icon: Icon(Feather.getIconData('user'), size: 20.0), route: UserPage())
];

final List<_Item> TAB_BAR_DATA = <_Item>[
  _Item(name: '最新', route: LatestPage()),
  _Item(name: '随机', route: RandomPage()),
  _Item(name: '热门', route: PopularPage()),
  _Item(name: '分类', route: CategoryPage())
];

class _Item {
  final String name;
  final Icon icon;
  final Widget route;

  _Item({this.name, this.icon, this.route});
}
