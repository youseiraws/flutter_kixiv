import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../model/model.dart';
import '../../util/util.dart';
import '../../widget/widget.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CategoryModel>(builder: (context, child, model) {
      return HomeList<CategoryTabTappedEvent>(
        header: ScopedModelDescendant<CategoryModel>(builder: (context, child, model) {
          return CategoryHeader(
            hintTags: model.hintTags,
            type: model.type,
            order: model.order,
            name_partterns: model.name_partterns,
            changeType: model.changeType,
            changeOrder: model.changeOrder,
            changeName: model.changeName,
            changeNameParttern: model.changeNameParttern,
          );
        }),
        body: ScopedModelDescendant<CategoryModel>(builder: (context, child, model) {
          if (!model.isLoaded && model.categories.isEmpty) {
            model.loadCategory();
          }
          return CategoryBody(categories: model.categories, count: model.count, loadCategory: model.loadCategory);
        }),
        isRefreshing: model.isRefreshing,
        isLoaded: model.isLoaded,
        load: model.loadCategory,
        refresh: model.refreshCategory,
      );
    });
  }
}
