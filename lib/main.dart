import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'config/config.dart';
import 'model/model.dart';
import 'page/parent/container_page.dart';

void main() => runApp(KixivApp());

class KixivApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<BaseModel>(
      model: BaseModel(),
      child: ScopedModel<SettingModel>(
        model: SettingModel(),
        child: ScopedModel<LatestModel>(
          model: LatestModel(),
          child: ScopedModel<RandomModel>(
            model: RandomModel(),
            child: ScopedModel<PopularModel>(
              model: PopularModel(),
              child: ScopedModel<CategoryModel>(
                model: CategoryModel(),
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: APP_NAME,
                  theme: GLOBAL_THEME,
                  home: ContainerPage(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
