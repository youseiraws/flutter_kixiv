import 'package:sqflite/sqflite.dart';

import '../entity/entity.dart';
import 'helper.dart';

class TagHelper {
  static final TagHelper _helper = TagHelper._internal();

  factory TagHelper() => _helper;

  TagHelper._internal();

  final String tableName = 'tag';
  final String columnId = 'id';
  final String columnName = 'name';
  final String columnCount = 'count';
  final String columnType = 'type';
  final String columnAmbiguous = 'ambiguous';
  final String columnOperate_time = 'operate_time';

  create(Database db) async {
    await db.execute('''
    CREATE TABLE $tableName(
    $columnId INTEGER PRIMARY KEY,
    $columnName TEXT,
    $columnCount INTEGER,
    $columnType INTEGER,
    $columnAmbiguous INTEGER,
    $columnOperate_time INTEGER)
    ''');
  }

  insert(dynamic tag) async {
    if (tag is Tag) {
      await _insert(tag);
    } else if (tag is List<Tag>) {
      tag.forEach((_tag) async => await _insert(_tag));
    }
  }

  _insert(Tag tag) async {
    if (await isExist(id: tag.id, name: tag.name)) {
      if (await isExpired(id: tag.id, name: tag.name)) {
        await update(tag);
      }
    } else {
      db.then((_) async {
        tag.operate_time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        await _.insert(tableName, tag.toSql());
      });
    }
  }

  Future<Tag> query({int id, String name}) async {
    List<String> where = [];
    List<dynamic> whereArgs = [];
    if (id != null) {
      where.add('$columnId = ?');
      whereArgs.add(id);
    }
    if (name != null) {
      where.add('$columnName = ?');
      whereArgs.add(name);
    }
    return db.then((_) async {
      List<Map<String, dynamic>> result = await _.query(tableName, where: where.join(' AND '), whereArgs: whereArgs);
      if (result.isNotEmpty) {
        return Tag.fromSql(result.first);
      }
      return null;
    });
  }

  Future<int> update(Tag tag) async {
    tag.operate_time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return db.then((_) async => await _.update(tableName, tag.toSql(), where: '$columnId = ?', whereArgs: [tag.id]));
  }

  Future<int> delete({int id}) async {
    if (id == null) {
      return db.then((_) async => await _.delete(tableName));
    } else {
      return db.then((_) async => await _.delete(tableName, where: '$columnId = ?', whereArgs: [id]));
    }
  }

  Future<bool> isExist({int id, String name}) async {
    Tag tag = await query(id: id, name: name);
    return tag != null;
  }

  Future<bool> isExpired({int id, String name}) async {
    Tag tag = await query(id: id, name: name);
    return tag != null && tag.operate_time != null
        ? DateTime.fromMillisecondsSinceEpoch(tag.operate_time * 1000).difference(DateTime.now()).inDays > EXPIRED_DAY
            ? true
            : false
        : true;
  }
}
