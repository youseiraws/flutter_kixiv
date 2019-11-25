import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kixiv/entity/entity.dart';

import '../helper/helper.dart';

class NoBehaviorView extends StatelessWidget {
  final Widget child;

  NoBehaviorView({@required this.child});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: _Behavior(),
      child: child,
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  final double padding;

  LoadingIndicator({this.padding = 12.0});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: padding),
        child: RefreshProgressIndicator());
  }
}

class SearchButton extends StatelessWidget {
  final onPressed;

  SearchButton({@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: IconButton(
          icon: Icon(
            Feather.getIconData('search'),
            size: 20.0,
          ),
          onPressed: onPressed),
    );
  }
}

class TagStarButton extends StatefulWidget {
  final int id;

  TagStarButton(this.id);

  @override
  _TagStarButtonState createState() => _TagStarButtonState();
}

class _TagStarButtonState extends State<TagStarButton> {
  bool isStarred = false;

  @override
  void initState() {
    _initStarState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isStarred ? Ionicons.getIconData('md-star') : Ionicons.getIconData('md-star-outline'),
        size: 26.0,
      ),
      onPressed: _changeStarState,
    );
  }

  _initStarState() async {
    bool _isStarred = await StarredTagHelper().isExist(widget.id);
    setState(() => isStarred = _isStarred);
  }

  _changeStarState() async {
    isStarred
        ? await StarredTagHelper().delete(id: widget.id)
        : await StarredTagHelper().insert(StarredTag(id: widget.id));
    setState(() => isStarred = !isStarred);
  }
}

class _Behavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return Platform.isAndroid || Platform.isFuchsia ? child : super.buildViewportChrome(context, child, axisDirection);
  }
}

class InfoRow extends StatelessWidget {
  final String text;
  final String value;

  InfoRow({this.text, this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Color(0xffe9e9e9))), color: Colors.white),
      child: Row(
        children: <Widget>[Chip(label: Text(text)), Spacer(), Text(value)],
      ),
    );
  }
}

class AutoScrollListView extends StatefulWidget {
  final List<Widget> children;
  final onScrollEnd;

  AutoScrollListView({this.children, this.onScrollEnd});

  @override
  _AutoScrollListViewState createState() => _AutoScrollListViewState();
}

class _AutoScrollListViewState extends State<AutoScrollListView> {
  ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController(keepScrollOffset: false);
    _scrollHandler();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(controller: _controller, shrinkWrap: true, children: widget.children);
  }

  _scrollHandler() {
    _controller.addListener(() {
      if (widget.onScrollEnd != null &&
          _controller.offset == _controller.position.maxScrollExtent &&
          _controller.position.maxScrollExtent != 0) {
        widget.onScrollEnd();
      }
    });
    Timer(Duration(milliseconds: 3000), () {
      if (_controller.hasClients) {
        if (widget.onScrollEnd != null && _controller.position.maxScrollExtent == 0) {
          widget.onScrollEnd();
        } else {
          _controller.animateTo(_controller.position.maxScrollExtent,
              duration: Duration(milliseconds: (_controller.position.maxScrollExtent * 40).toInt()),
              curve: Curves.linear);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

showLoadingDialog(BuildContext context, {String msg}) async {
  return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.only(top: 26.0),
                child: Text(msg == null ? '正在加载，请稍后...' : msg),
              )
            ],
          ),
        );
      });
}
