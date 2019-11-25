import 'package:scoped_model/scoped_model.dart';

import '../entity/entity.dart';

class SettingModel extends Model {
  List<Rating> _ratings;

  List<Rating> get ratings => _ratings;
}
