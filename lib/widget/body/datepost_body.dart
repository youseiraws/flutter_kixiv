import 'package:flutter/material.dart';

import '../../entity/entity.dart';
import '../widget.dart';

class DatePostBody extends StatelessWidget {
  final HeaderType type;
  final List<DatePost> dateposts;
  final List<Post> all;
  final loadDatePost;

  DatePostBody({this.type, @required this.dateposts, @required this.all, @required this.loadDatePost});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: dateposts.length,
        itemBuilder: (context, index) => _createItem(context, index, dateposts, loadDatePost));
  }

  Widget _createItem(BuildContext context, int index, List<DatePost> dateposts, loadDatePost) {
    if (index == dateposts.length - 1) {
      loadDatePost();
      return LoadingIndicator(padding: 24.0);
    } else {
      return Container(
          margin: EdgeInsets.only(top: index == 0 ? 0.0 : 24.0),
          child: PostTile(type: type, datas: dateposts[index], all: all, load: loadDatePost));
    }
  }
}
