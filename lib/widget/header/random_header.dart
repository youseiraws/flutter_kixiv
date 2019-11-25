import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kixiv/widget/miscellaneous.dart';

import '../../entity/entity.dart';

class RandomHeader extends StatefulWidget {
  final List<Tag> hintTags;
  final List<Tag> tags;
  final changeName;
  final changeTags;

  RandomHeader({@required this.hintTags, @required this.tags, @required this.changeName, @required this.changeTags});

  @override
  _RandomHeaderState createState() => _RandomHeaderState();
}

class _RandomHeaderState extends State<RandomHeader> {
  TextEditingController _controller;
  Timer _timer;
  bool _isTagHeader = true;
  Tag _selected;

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
      itemCount: widget.tags.length,
      itemBuilder: (context, index) {
        return Chip(
          backgroundColor: tagTypeToColor(widget.tags[index].type),
          label: Text(widget.tags[index].name),
          onDeleted: () => widget.changeTags(widget.tags[index], false),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(width: 4.0);
      },
    );
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
            border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0)),
        onChanged: (String name) => _changeName(name),
        onSubmitted: (String name) => _switchHeader(),
      ),
    );
  }

  _switchHeader() {
    _timer.cancel();
    if (!_isTagHeader) {
      if (_selected != null && _controller.text.isNotEmpty) {
        widget.changeTags(_selected, true);
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
      _selected = await showMenu<Tag>(
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
      _selected ??= widget.hintTags[0];
      _controller.text = _selected?.name;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }
}
