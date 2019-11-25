import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../entity/entity.dart';
import 'helper.dart';

class PostHelper {
  static final PostHelper _helper = PostHelper._internal();

  factory PostHelper() => _helper;

  PostHelper._internal() {
    FlutterDownloader.registerCallback((task_id, status, progress) async {
      if (status == DownloadTaskStatus.complete) {
        PostTask postTask = await PostTaskHelper().query(task_id);
        if (postTask != null) {
          PostHelper().updatePostUrl(id: postTask.id, postType: postTask.postType, url: postTask.local_url);
        }
      } else if (status == DownloadTaskStatus.failed) {
        _retry(task_id: task_id);
      }
    });
  }

  final String tableName = 'post';
  final String columnId = 'id';
  final String columnTags = 'tags';
  final String columnCreated_at = 'created_at';
  final String columnCreator_id = 'creator_id';
  final String columnAuthor = 'author';
  final String columnChange = 'change';
  final String columnSource = 'source';
  final String columnScore = 'score';
  final String columnMd5 = 'md5';
  final String columnFile_size = 'file_size';
  final String columnFile_url = 'file_url';
  final String columnIs_shown_in_index = 'is_shown_in_index';
  final String columnPreview_url = 'preview_url';
  final String columnPreview_width = 'preview_width';
  final String columnPreview_height = 'preview_height';
  final String columnActual_preview_width = 'actual_preview_width';
  final String columnActual_preview_height = 'actual_preview_height';
  final String columnSample_url = 'sample_url';
  final String columnSample_width = 'sample_width';
  final String columnSample_height = 'sample_height';
  final String columnSample_file_size = 'sample_file_size';
  final String columnJpeg_url = 'jpeg_url';
  final String columnJpeg_width = 'jpeg_width';
  final String columnJpeg_height = 'jpeg_height';
  final String columnJpeg_file_size = 'jpeg_file_size';
  final String columnRating = 'rating';
  final String columnHas_children = 'has_children';
  final String columnParent_id = 'parent_id';
  final String columnStatus = 'status';
  final String columnWidth = 'width';
  final String columnHeight = 'height';
  final String columnIs_held = 'is_held';
  final String columnFrames_pending_string = 'frames_pending_string';
  final String columnFrames_pending = 'frames_pending';
  final String columnFrames_string = 'frames_string';
  final String columnFrames = 'frames';
  final String columnPreview_local_url = 'preview_local_url';
  final String columnSample_local_url = 'sample_local_url';
  final String columnJpeg_local_url = 'jpeg_local_url';
  final String columnFile_local_url = 'file_local_url';
  final String columnOperate_time = 'operate_time';

  create(Database db) async {
    await db.execute('''
    CREATE TABLE $tableName(
    $columnId INTEGER PRIMARY KEY,
    $columnTags TEXT,
    $columnCreated_at INTEGER,
    $columnCreator_id INTEGER,
    $columnAuthor TEXT,
    $columnChange INTEGER,
    $columnSource TEXT,
    $columnScore INTEGER,
    $columnMd5 TEXT,
    $columnFile_size INTEGER,
    $columnFile_url TEXT,
    $columnIs_shown_in_index INTEGER,
    $columnPreview_url TEXT,
    $columnPreview_width INTEGER,
    $columnPreview_height INTEGER,
    $columnActual_preview_width INTEGER,
    $columnActual_preview_height INTEGER,
    $columnSample_url TEXT,
    $columnSample_width INTEGER,
    $columnSample_height INTEGER,
    $columnSample_file_size INTEGER,
    $columnJpeg_url TEXT,
    $columnJpeg_width INTEGER,
    $columnJpeg_height INTEGER,
    $columnJpeg_file_size INTEGER,
    $columnRating TEXT,
    $columnHas_children INTEGER,
    $columnParent_id INTEGER,
    $columnStatus TEXT,
    $columnWidth INTEGER,
    $columnHeight INTEGER,
    $columnIs_held INTEGER,
    $columnFrames_pending_string TEXT,
    $columnFrames_pending TEXT,
    $columnFrames_string TEXT,
    $columnFrames TEXT,
    $columnPreview_local_url TEXT,
    $columnSample_local_url TEXT,
    $columnJpeg_local_url TEXT,
    $columnFile_local_url TEXT,
    $columnOperate_time INTEGER)
    ''');
  }

  synchronize(dynamic post) async {
    if (post is Post) {
      await _synchronize(post);
    } else if (post is List<Post>) {
      post.forEach((_post) async {
        return await _synchronize(_post);
      });
    }
  }

  _synchronize(Post post) async {
    await _downloadImages(post);
    if (await isExist(post.id)) {
      if (await isExpired(post.id)) {
        await update(post);
      }
      Post _post = await query(post.id);
      post.preview_local_url = _post.preview_local_url;
      post.sample_local_url = _post.sample_local_url;
      post.jpeg_local_url = _post.jpeg_local_url;
      post.file_local_url = _post.file_local_url;
    } else {
      await insert(post);
    }
  }

  insert(Post post) async {
    db.then((_) async {
      post.operate_time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await _.insert(tableName, post.toSql());
    });
  }

  Future<Post> query(int id) async {
    return db.then((_) async {
      List<Map<String, dynamic>> result = await _.query(tableName, where: '$columnId = ?', whereArgs: [id]);
      if (result.isNotEmpty) {
        return Post.fromSql(result.first);
      }
      return null;
    });
  }

  Future<int> update(Post post) async {
    post.operate_time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return db.then((_) async => await _.update(tableName, post.toSql(), where: '$columnId = ?', whereArgs: [post.id]));
  }

  updatePostUrl({@required int id, @required PostType postType, @required String url}) {
    return db.then((_) async => await _.update(
        tableName, <String, dynamic>{'${postTypeToString(postType)}_local_url': url},
        where: '$columnId = ?', whereArgs: [id]));
  }

  Future<int> delete({int id}) async {
    if (id == null) {
      return db.then((_) async => await _.delete(tableName));
    } else {
      return db.then((_) async => await _.delete(tableName, where: '$columnId', whereArgs: [id]));
    }
  }

  Future<bool> isExist(int id) async {
    Post post = await query(id);
    return post != null;
  }

  Future<bool> isExpired(int id) async {
    Post post = await query(id);
    return post != null && post.operate_time != null
        ? DateTime.fromMillisecondsSinceEpoch(post.operate_time * 1000).difference(DateTime.now()).inDays > EXPIRED_DAY
            ? true
            : false
        : true;
  }

  _downloadImages(Post post) async {
    await _downloadImage(post.id, PostType.preview, post.preview_url);
    await _downloadImage(post.id, PostType.sample, post.sample_url);
//    await _downloadImage(post.id, PostType.jpeg, post.jpeg_url);
//    await _downloadImage(post.id, PostType.file, post.file_url);
  }

  _downloadImage(int id, PostType postType, String url) async {
    if (url.isEmpty) {
      return '';
    }
    String savedDir = join((await getApplicationDocumentsDirectory()).path, id.toString(), postTypeToString(postType));
    String fileName = url.split('/').last;
    Directory path = Directory(savedDir);

    if (!File(join(savedDir, fileName)).existsSync()) {
      if (!path.existsSync()) {
        path.createSync(recursive: true);
      }
      _enqueue(url: url, savedDir: savedDir, fileName: fileName, id: id, postType: postType);
    } else {
      Post post = await PostHelper().query(id);
      if (post != null && (postTypeToUrl(postType, post) == null || postTypeToUrl(postType, post).isEmpty)) {
        PostHelper().updatePostUrl(id: id, postType: postType, url: join(savedDir, fileName));
      }
    }
  }

  _enqueue(
      {@required String url,
      @required String savedDir,
      @required String fileName,
      @required int id,
      @required PostType postType}) async {
    String task_id = await FlutterDownloader.enqueue(
        url: url, savedDir: savedDir, fileName: fileName, showNotification: false, openFileFromNotification: false);
    await PostTaskHelper()
        .insert(PostTask(task_id: task_id, id: id, postType: postType, local_url: join(savedDir, fileName)));
  }

  _retry({@required task_id}) async {
    PostTask postTask = await PostTaskHelper().query(task_id);
    if (postTask != null) {
      String newTask_id = await FlutterDownloader.retry(taskId: task_id);
      await PostTaskHelper().insert(
          PostTask(task_id: newTask_id, id: postTask.id, postType: postTask.postType, local_url: postTask.local_url));
    }
  }
}
