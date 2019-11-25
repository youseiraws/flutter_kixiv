import 'dart:ui' as ui show Image;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../../entity/entity.dart';
import '../../page/page.dart';
import '../widget.dart';

class CategoryBody extends StatelessWidget {
  final List<Category> categories;
  final num count;
  final loadCategory;
  static const double RADIUS = 4.0;

  CategoryBody({@required this.categories, @required this.count, @required this.loadCategory});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 20.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 1.0, mainAxisSpacing: 8.0, crossAxisSpacing: 8.0),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          if (index == categories.length - 1 && index != count - 1) {
            loadCategory();
            return LoadingIndicator();
          } else {
            return Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(RADIUS)),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  AspectRatio(
                      aspectRatio: 1.0,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(RADIUS),
                          child: ImageBody(
                            local_url: categories[index].cover.preview_local_url,
                            url: categories[index].cover.preview_url,
                            createChild: (ui.Image image) => Stack(
                              children: <Widget>[
                                AspectRatio(
                                    aspectRatio: 1.0,
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
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => TagPage(tag: categories[index].tag))),
                                  ),
                                ))
                              ],
                            ),
                          ))),
                  Positioned(
                    child: Container(
                      height: 20.0,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(RADIUS), bottomRight: Radius.circular(RADIUS)),
                        color: tagTypeToColor(categories[index].tag.type).withOpacity(0.6),
                      ),
                      child: Text(categories[index].tag.name,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 16.0)),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}
