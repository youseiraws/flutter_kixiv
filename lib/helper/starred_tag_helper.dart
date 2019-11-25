import 'package:sqflite/sqflite.dart';

import '../entity/entity.dart';
import 'helper.dart';

class StarredTagHelper {
  static final StarredTagHelper _helper = StarredTagHelper._internal();

  factory StarredTagHelper() => _helper;

  StarredTagHelper._internal();

  final String tableName = 'starred_tag';
  final String columnId = 'id';
  final String columnOperate_time = 'operate_time';

  create(Database db) async {
    await db.execute('''
    CREATE TABLE $tableName(
    $columnId INTEGER PRIMARY KEY,
    $columnOperate_time INTEGER)
    ''');
  }

  insert(dynamic starredTag) async {
    if (starredTag is StarredTag) {
      await _insert(starredTag);
    } else if (starredTag is List<StarredTag>) {
      starredTag.forEach((_starredTag) async => await _insert(_starredTag));
    }
  }

  Future<int> _insert(StarredTag starredTag) async {
    if (await isExist(starredTag.id)) {
      return await update(starredTag);
    } else {
      return db.then((_) async {
        starredTag.operate_time = DateTime.now().millisecondsSinceEpoch;
        return await _.insert(tableName, starredTag.toSql());
      });
    }
  }

  Future<StarredTag> query(int id) async {
    List<String> where = [];
    List<dynamic> whereArgs = [];
    if (id != null) {
      where.add('$columnId = ?');
      whereArgs.add(id);
    }
    return db.then((_) async {
      List<Map<String, dynamic>> result = await _.query(tableName, where: where.join(' AND '), whereArgs: whereArgs);
      if (result.isNotEmpty) {
        return StarredTag.fromSql(result.first);
      }
      return null;
    });
  }

  Future<int> update(StarredTag starredTag) async {
    starredTag.operate_time = DateTime.now().millisecondsSinceEpoch;
    return db.then(
        (_) async => await _.update(tableName, starredTag.toSql(), where: '$columnId = ?', whereArgs: [starredTag.id]));
  }

  Future<int> delete({int id}) async {
    if (id == null) {
      return db.then((_) async => await _.delete(tableName));
    } else {
      return db.then((_) async => await _.delete(tableName, where: '$columnId = ?', whereArgs: [id]));
    }
  }

  Future<bool> isExist(int id) async {
    StarredTag starredTag = await query(id);
    return starredTag != null;
  }
}
