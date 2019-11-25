import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'post_helper.dart';
import 'post_task_helper.dart';
import 'starred_tag_helper.dart';
import 'tag_helper.dart';

export 'post_helper.dart';
export 'post_task_helper.dart';
export 'starred_tag_helper.dart';
export 'tag_helper.dart';

const DATABASE_NAME = 'kixiv.db';
const EXPIRED_DAY = 7;

Database _db;

Future<Database> get db async {
  if (_db != null) {
    return _db;
  }
  String databasesPath = await getDatabasesPath();
  String path = join(databasesPath, DATABASE_NAME);
  return await openDatabase(path, version: 1, onCreate: _onCreate);
}

_onCreate(Database db, int version) {
  TagHelper().create(db);
  StarredTagHelper().create(db);
  PostHelper().create(db);
  PostTaskHelper().create(db);
}

close() async {
  db.then((_) => _.close());
}
