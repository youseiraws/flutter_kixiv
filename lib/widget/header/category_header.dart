import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kixiv/widget/miscellaneous.dart';

import '../../entity/entity.dart';

class CategoryHeader extends StatefulWidget {
  final List<Tag> hintTags;
  final TagType type;
  final TagOrder order;
  final List<String> name_partterns;
  final changeType;
  final changeOrder;
  final changeName;
  final changeNameParttern;

  CategoryHeader(
      {@required this.hintTags,
      @required this.type,
      @required this.order,
      @required this.name_partterns,
      @required this.changeType,
      @required this.changeOrder,
      @required this.changeName,
      @required this.changeNameParttern});

  @override
  _CategoryHeaderState createState() => _CategoryHeaderState();
}

class _CategoryHeaderState extends State<CategoryHeader> {
  TextEditingController _controller;
  Timer _timer;
  bool _isTagHeader = true;

  @override
  void initState() {
    _timer = Timer(Duration(), () {});
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      SizedBox(width: 18.0),
      Expanded(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(child: child, opacity: animation);
          },
          child: _isTagHeader ? _tagHeader() : _searchHeader(),
        ),
      ),
      SearchButton(onPressed: _switchHeader)
    ]);
  }

  Widget _tagHeader() {
    return ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.name_partterns.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return PopupMenuButton(
                offset: Offset(0, 48.0),
                elevation: 0.0,
                child: Chip(backgroundColor: tagTypeToColor(widget.type), label: Text(tagTypeToString(widget.type))),
                onSelected: (TagType type) {
                  widget.changeType(type);
                },
                itemBuilder: (context) {
                  return TagType.values.map((TagType type) {
                    return PopupMenuItem<TagType>(
                        value: type, child: Text(tagTypeToString(type), style: TextStyle(color: tagTypeToColor(type))));
                  }).toList();
                });
          } else if (index == 1) {
            return PopupMenuButton(
                offset: Offset(0, 48.0),
                elevation: 0.0,
                child: Chip(label: Text(tagOrderToString(widget.order))),
                onSelected: (TagOrder order) {
                  widget.changeOrder(order);
                },
                itemBuilder: (context) {
                  return TagOrder.values.map((TagOrder order) {
                    return PopupMenuItem<TagOrder>(value: order, child: Text(tagOrderToString(order)));
                  }).toList();
                });
          } else {
            return Chip(
                label: Text(widget.name_partterns[index - 2]),
                onDeleted: () => widget.changeNameParttern(widget.name_partterns[index - 2], false));
          }
        },
        separatorBuilder: (context, index) {
          return SizedBox(width: 4.0);
        });
  }

  Widget _searchHeader() {
    return Container(
      decoration: BoxDecoration(color: Color(0xffebebeb), borderRadius: BorderRadius.circular(4.0)),
      child: TextField(
        controller: _controller,
        cursorColor: Theme.of(context).primaryColor,
        cursorRadius: Radius.circular(6.0),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        ),
        onChanged: (String name) => _changeName(name),
        onSubmitted: (String name) => _switchHeader(),
      ),
    );
  }

  _switchHeader() {
    _timer.cancel();
    if (!_isTagHeader) {
      if (_controller.text.isNotEmpty) {
        widget.changeNameParttern(_controller.text, true);
      }
      _controller.clear();
    }
    setState(() {
      _isTagHeader = !_isTagHeader;
    });
  }

  _changeName(String tag) {
    _timer.cancel();
    if (tag.isNotEmpty) {
      _timer = Timer(Duration(milliseconds: 1500), () => _showHintTag(tag));
    }
  }

  _showHintTag(String tag) async {
    await widget.changeName(tag);
    if (widget.hintTags.isNotEmpty) {
      Tag selected = await showMenu<Tag>(
          context: context,
          elevation: 0.0,
          position: RelativeRect.fromLTRB(50.0, 120.0, 50.0, 0.0),
          items: widget.hintTags.map((Tag tag) {
            return PopupMenuItem<Tag>(
              height: 32.0,
              value: tag,
              child: SizedBox(
                width: 300.0,
                child: Text(
                  '${tag.name}(${tag.count})',
                  style: TextStyle(color: tagTypeToColor(tag.type)),
                ),
              ),
            );
          }).toList());
      _controller.text = selected?.name;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }
}
