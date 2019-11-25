import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../model/model.dart';
import '../../util/util.dart';
import '../../widget/widget.dart';

class RandomPage extends StatefulWidget {
  @override
  _RandomPageState createState() => _RandomPageState();
}

class _RandomPageState extends State<RandomPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<RandomModel>(
      builder: (context, child, model) {
        return HomeList<RandomTabTappedEvent>(
          header: ScopedModelDescendant<RandomModel>(
            builder: (context, child, model) {
              return RandomHeader(
                hintTags: model.hintTags,
                tags: model.tags,
                changeName: model.changeName,
                changeTags: model.changeTags,
              );
            },
          ),
          body: ScopedModelDescendant<RandomModel>(
            builder: (context, child, model) {
              if (!model.isLoaded && model.randoms.isEmpty) {
                model.loadRandom();
              }
              return PostBody(posts: model.randoms, count: model.count, loadPost: model.loadRandom);
            },
          ),
          isRefreshing: model.isRefreshing,
          isLoaded: model.isLoaded,
          load: model.loadRandom,
          refresh: model.refreshRandom,
        );
      },
    );
  }
}
