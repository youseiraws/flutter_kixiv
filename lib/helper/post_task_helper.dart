import 'package:sqflite/sqflite.dart';

import '../entity/entity.dart';
import 'helper.dart';

class PostTaskHelper {
  static final PostTaskHelper _helper = PostTaskHelper._internal();

  factory PostTaskHelper() => _helper;

  PostTaskHelper._internal();

  final String tableName = 'post_task';
  final String columnTask_id = 'task_id';
  final String columnId = 'id';
  final String columnPost_type = 'post_type';
  final String columnLocal_url = 'local_url';
  final String columnOperate_time = 'operate_time';

  create(Database db) async {
    await db.execute('''
    CREATE TABLE $tableName(
    $columnTask_id TEXT PRIMARY KEY,
    $columnId INTEGER,
    $columnPost_type TEXT,
    $columnLocal_url TEXT,
    $columnOperate_time INTEGER)
    ''');
  }

  insert(dynamic postTask) async {
    if (postTask is PostTask) {
      await _insert(postTask);
    } else if (postTask is List<PostTask>) {
      postTask.forEach((_postTask) async => await _insert(_postTask));
    }
  }

  _insert(PostTask postTask) async {
    if (await isExist(postTask.task_id)) {
      await update(postTask);
    } else {
      db.then((_) async {
        postTask.operate_time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        await _.insert(tableName, postTask.toSql());
      });
    }
  }

  Future<PostTask> query(String task_id) async {
    return db.then((_) async {
      List<Map<String, dynamic>> result = await _.query(tableName, where: '$columnTask_id = ?', whereArgs: [task_id]);
      if (result.isNotEmpty) {
        return PostTask.fromSql(result.first);
      }
      return null;
    });
  }

  Future<int> update(PostTask postTask) async {
    postTask.operate_time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return db.then((_) async =>
        await _.update(tableName, postTask.toSql(), where: '$columnTask_id = ?', whereArgs: [postTask.task_id]));
  }

  Future<int> delete({String task_id}) async {
    if (task_id == null) {
      return db.then((_) async => await _.delete(tableName));
    } else {
      return db.then((_) async => await _.delete(tableName, where: '$columnTask_id', whereArgs: [task_id]));
    }
  }

  Future<bool> isExist(String task_id) async {
    PostTask postTask = await query(task_id);
    return postTask != null;
  }
}
