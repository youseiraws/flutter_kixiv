import 'dart:ui' as ui show Image;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../../entity/entity.dart';
import '../../page/page.dart';
import '../widget.dart';

class PostTile extends StatelessWidget {
  final HeaderType type;
  final DatePost datas;
  final List<Post> all;
  final load;

  PostTile({this.type, @required this.datas, this.all, this.load});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TileHeader(type: type, date: datas.date),
        TileBody(posts: datas.posts, physics: NeverScrollableScrollPhysics(), all: all, load: load, needLoad: false)
      ],
    );
  }
}

class TileHeader extends StatelessWidget {
  final DateTime date;
  final HeaderType type;

  TileHeader({this.type = HeaderType.day, @required this.date});

  @override
  Widget build(BuildContext context) {
    Widget dateRow;
    switch (type) {
      case HeaderType.day:
        dateRow = Row(children: <Widget>[
          Text.rich(
            TextSpan(children: <TextSpan>[
              TextSpan(
                text: '${date.day}',
                style: TextStyle(fontSize: 24.0, color: Theme.of(context).primaryColor),
              ),
              TextSpan(text: '/${date.month}', style: TextStyle(fontSize: 18.0, color: Theme.of(context).primaryColor)),
              TextSpan(text: '/${date.year}', style: TextStyle(fontSize: 12.0, color: Theme.of(context).primaryColor)),
            ]),
          ),
        ]);
        break;
      case HeaderType.week:
        DateTime weekend = date.add(Duration(days: 6));
        dateRow = Row(children: <Widget>[
          Text.rich(
            TextSpan(children: <TextSpan>[
              TextSpan(
                text: '${weekend.day}',
                style: TextStyle(fontSize: 24.0, color: Theme.of(context).primaryColor),
              ),
              TextSpan(
                  text: '/${weekend.month}', style: TextStyle(fontSize: 18.0, color: Theme.of(context).primaryColor)),
              TextSpan(
                  text: '/${weekend.year}', style: TextStyle(fontSize: 12.0, color: Theme.of(context).primaryColor)),
              TextSpan(
                text: ' - ${date.day}',
                style: TextStyle(fontSize: 24.0, color: Theme.of(context).primaryColor),
              ),
              TextSpan(text: '/${date.month}', style: TextStyle(fontSize: 18.0, color: Theme.of(context).primaryColor)),
              TextSpan(text: '/${date.year}', style: TextStyle(fontSize: 12.0, color: Theme.of(context).primaryColor)),
            ]),
          ),
        ]);
        break;
      case HeaderType.month:
        dateRow = Row(children: <Widget>[
          Text.rich(
            TextSpan(children: <TextSpan>[
              TextSpan(
                text: '${date.month}',
                style: TextStyle(fontSize: 24.0, color: Theme.of(context).primaryColor),
              ),
              TextSpan(text: '/${date.year}', style: TextStyle(fontSize: 18.0, color: Theme.of(context).primaryColor)),
            ]),
          ),
        ]);
        break;
    }
    return Container(
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(bottom: 2.0),
      child: dateRow,
    );
  }
}

class TileBody extends StatelessWidget {
  final List<Post> posts;
  final num count;
  final ScrollPhysics physics;
  final List<Post> all;
  final load;
  final bool needLoad;
  static const double RADIUS = 2.0;

  TileBody(
      {@required this.posts,
      this.count = double.infinity,
      @required this.physics,
      this.all,
      this.load,
      this.needLoad = true});

  @override
  Widget build(BuildContext context) {
    return NoBehaviorView(
      child: GridView.builder(
          shrinkWrap: true,
          physics: physics,
          padding: EdgeInsets.symmetric(vertical: needLoad ? 20.0 : 0.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 16 / 10, mainAxisSpacing: 6.0, crossAxisSpacing: 6.0),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            if (needLoad && load != null && index == posts.length - 1 && index != count - 1) {
              load();
              return LoadingIndicator();
            } else {
              return Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(RADIUS)),
                  child: Stack(alignment: Alignment.bottomCenter, children: <Widget>[
                    AspectRatio(
                        aspectRatio: 16 / 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(RADIUS),
                          child: ImageBody(
                            local_url: posts[index].preview_local_url,
                            url: posts[index].preview_url,
                            createChild: (ui.Image image) => Stack(children: <Widget>[
                              AspectRatio(
                                  aspectRatio: 16 / 10,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(RADIUS),
                                      child: ExtendedRawImage(fit: BoxFit.cover, image: image))),
                              Positioned.fill(
                                  child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(RADIUS),
                                        splashColor: Theme.of(context).primaryColor.withOpacity(0.3),
                                        highlightColor: Theme.of(context).primaryColor.withOpacity(0.1),
                                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => PostPage(
                                                posts: all == null ? posts : all,
                                                count: count,
                                                id: posts[index].id,
                                                load: load))),
                                      )))
                            ]),
                          ),
                        )),
//                    Positioned(
//                      child: Container(
//                          height: 20,
//                          width: double.infinity,
//                          alignment: Alignment.center,
//                          decoration: BoxDecoration(
//                              borderRadius: BorderRadius.only(
//                                  bottomLeft: Radius.circular(RADIUS), bottomRight: Radius.circular(RADIUS)),
//                              color: Colors.grey.withOpacity(0.6)),
//                          child: Text('${posts[index].width} x ${posts[index].height}',
//                              maxLines: 1,
//                              textAlign: TextAlign.center,
//                              style: TextStyle(color: Theme.of(context).primaryColor))),
//                    )
                  ]));
            }
          }),
    );
  }
}

enum HeaderType { day, week, month }
