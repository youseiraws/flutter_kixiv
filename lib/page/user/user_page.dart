import 'package:flutter/material.dart';
import 'package:kixiv/config/config.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + BAR_HEIGHT),
            child: Column(
              children: <Widget>[],
            ),
          ),
          Positioned(
            child: _createBar(),
          )
        ],
      ),
    );
  }

  Widget _createBar() {
    return Container(
      constraints: BoxConstraints.expand(height: BAR_HEIGHT),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: BAR_BORDER_SIZE, color: BAR_BORDER_COLOR)),
          color: BAR_BACKGROUND_COLOR),
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          InkWell(
            splashColor: SPLASH_COLOR,
            highlightColor: HIGHLIGHT_COLOR,
            child: Text(USER_BAR_TITLE, style: TextStyle(fontSize: BAR_FONT_SIZE)),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
