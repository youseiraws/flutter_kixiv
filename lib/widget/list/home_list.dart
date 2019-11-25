import 'dart:async';

import 'package:flutter/material.dart';

import '../../util/event.dart';

class HomeList<T> extends StatefulWidget {
  final Widget header;
  final Widget body;
  final bool isRefreshing;
  final bool isLoaded;
  final load;
  final refresh;

  HomeList(
      {this.header,
      @required this.body,
      @required this.isRefreshing,
      this.isLoaded = false,
      @required this.load,
      @required this.refresh});

  @override
  _HomeListState<T> createState() => _HomeListState<T>();
}

class _HomeListState<T> extends State<HomeList<T>> {
  StreamSubscription _subscription;
  ScrollController _controller;
  final _height = 48.0;
  double _offsetY = 0.0;
  double _marginY = 0.0;
  double _opacity = 1.0;

  @override
  void initState() {
    _controller ??= ScrollController();
    if (widget.header != null) {
      _marginY = 48.0;
      _scrollHandler();
    }
    _tabTappedHandler();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: <Widget>[
      widget.header != null
          ? Positioned(
              child: Transform.translate(
              offset: Offset(0, _offsetY),
              child: Opacity(
                  opacity: _opacity,
                  child: Container(
                      height: 48.0,
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Color(0xffe9e9e9))), color: Colors.white),
                      child: Container(padding: EdgeInsets.symmetric(horizontal: 2.0), child: widget.header))),
            ))
          : Container(),
      Column(children: <Widget>[
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (!widget.isLoaded && (notification.metrics.pixels >= notification.metrics.maxScrollExtent / 3)) {
                widget.load();
              }
              return true;
            },
            child: RefreshIndicator(
              displacement: 52.0,
              onRefresh: () => widget.refresh(),
              child: Container(
                margin: EdgeInsets.only(top: _marginY),
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Stack(alignment: Alignment.topCenter, children: <Widget>[
                  PrimaryScrollController(controller: _controller, child: widget.body),
                  Visibility(
                      visible: widget.isRefreshing,
                      child: Positioned(top: widget.header != null ? 4.0 : 52.0, child: RefreshProgressIndicator()))
                ]),
              ),
            ),
          ),
        ),
      ]),
    ]);
  }

  void _tabTappedHandler() {
    _subscription ??= bus.on<T>().listen((T event) {
      if (_controller.offset != 0.0) {
        _controller.animateTo(0.0, duration: Duration(milliseconds: (_controller.offset) ~/ 5), curve: Curves.easeOut);
      } else {
        widget.refresh();
      }
    });
  }

  void _scrollHandler() {
    _controller.addListener(() {
      setState(() {
        if (_controller.offset < _height) {
          _offsetY = -_controller.offset;
          _marginY = _height - _controller.offset;
          _opacity = 1.0 - _controller.offset / _height;
        } else {
          _offsetY = -_height;
          _marginY = 0.0;
          _opacity = 0.0;
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _subscription.cancel();
    super.dispose();
  }
}
