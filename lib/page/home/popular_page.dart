import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../entity/entity.dart';
import '../../model/model.dart';
import '../../util/util.dart';
import '../../widget/widget.dart';

class PopularPage extends StatefulWidget {
  @override
  _PopularPageState createState() => _PopularPageState();
}

class _PopularPageState extends State<PopularPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<PopularModel>(builder: (context, child, model) {
      return HomeList<PopularTabTaggedEvent>(
        header: ScopedModelDescendant<PopularModel>(
          builder: (context, child, model) {
            return PopularHeader(type: model.type, changeType: model.changeType);
          },
        ),
        body: ScopedModelDescendant<PopularModel>(
          builder: (context, child, model) {
            if (model.populars.isEmpty) {
              model.loadPopular();
            }
            List<Post> posts = <Post>[];
            model.populars.map((DatePost popular) => posts.addAll(popular.posts)).toList();
            return DatePostBody(
                type: popularTypeToHeaderType(model.type),
                dateposts: model.populars,
                all: posts,
                loadDatePost: model.loadPopular);
          },
        ),
        isRefreshing: model.isRefreshing,
        isLoaded: model.isLoaded,
        load: model.loadPopular,
        refresh: model.refreshPopular,
      );
    });
  }
}
