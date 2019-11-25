import 'package:flutter/material.dart';
import 'package:kixiv/config/config.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../entity/entity.dart';
import '../../model/model.dart';
import '../../util/util.dart';
import '../../widget/widget.dart';

class TagPage extends StatefulWidget {
  final Tag tag;

  TagPage({@required this.tag});

  @override
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  TagModel model;

  @override
  void initState() {
    model = TagModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 50.0),
        child: Column(
          children: <Widget>[_createBody()],
        ),
      ),
      Positioned(
        child: _createBar(),
      )
    ]));
  }

  Widget _createBar() {
    return Container(
      constraints: BoxConstraints.expand(height: BAR_HEIGHT),
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(width: BAR_BORDER_SIZE, color: BAR_BORDER_COLOR)), color: BAR_BACKGROUND_COLOR),
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          InkWell(
            splashColor: SPLASH_COLOR,
            highlightColor: HIGHLIGHT_COLOR,
            child: Text(widget.tag.count == null ? widget.tag.name : '${widget.tag.name}(${widget.tag.count})',
                style: TextStyle(color: tagTypeToColor(widget.tag.type), fontSize: BAR_FONT_SIZE)),
            onTap: () => bus.fire(TagTabTappedEvent()),
          ),
          Positioned(
            left: 0.0,
            child: BackButton(),
          ),
          Positioned(
            right: 0.0,
            child: TagStarButton(widget.tag.id),
          )
        ],
      ),
    );
  }

  Widget _createBody() {
    return Expanded(
      child: ScopedModel<TagModel>(
          model: model,
          child: ScopedModelDescendant<TagModel>(builder: (context, child, model) {
            return HomeList<TagTabTappedEvent>(
                header: ScopedModelDescendant<TagModel>(
                  builder: (context, child, model) {
                    return TagHeader(mode: model.mode, changeMode: model.changeMode);
                  },
                ),
                body: ScopedModelDescendant<TagModel>(
                  builder: (context, child, model) {
                    if (!model.isLoaded) {
                      if (model.posts.isEmpty) {
                        model
                          ..initPost(widget.tag)
                          ..loadPost();
                      }
                      if (model.tag != widget.tag) {
                        model
                          ..initPost(widget.tag)
                          ..refreshPost();
                      }
                    }
                    return PostBody(posts: model.posts, count: model.count, loadPost: model.loadPost);
                  },
                ),
                isRefreshing: model.isRefreshing,
                load: model.loadPost,
                refresh: model.refreshPost);
          })),
    );
  }
}
