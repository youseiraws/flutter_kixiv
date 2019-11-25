import 'package:flutter/material.dart';

import '../../entity/entity.dart';
import '../widget.dart';

class PostBody extends StatelessWidget {
  final List<Post> posts;
  final num count;
  final loadPost;

  PostBody({@required this.posts, this.count = double.infinity, @required this.loadPost});

  @override
  Widget build(BuildContext context) {
    return TileBody(posts: posts, count: count, physics: ClampingScrollPhysics(), load: loadPost);
  }
}
