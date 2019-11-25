import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../entity/entity.dart';
import '../../model/model.dart';
import '../../util/util.dart';
import '../../widget/widget.dart';

class LatestPage extends StatefulWidget {
  @override
  _LatestPageState createState() => _LatestPageState();
}

class _LatestPageState extends State<LatestPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LatestModel>(builder: (context, child, model) {
      return HomeList<LatestTabTappedEvent>(
        body: ScopedModelDescendant<LatestModel>(
          builder: (context, child, model) {
            if (model.latests.isEmpty) {
              model.loadLatest();
            }
            List<Post> posts = <Post>[];
            model.latests.map((DatePost latest) => posts.addAll(latest.posts)).toList();
            return DatePostBody(
                type: HeaderType.day, dateposts: model.latests, all: posts, loadDatePost: model.loadLatest);
          },
        ),
        isRefreshing: model.isRefreshing,
        isLoaded: model.isLoaded,
        load: model.loadLatest,
        refresh: model.refreshLatest,
      );
    });
  }
}
