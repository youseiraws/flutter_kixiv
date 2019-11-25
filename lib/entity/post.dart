import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../widget/list/common_list.dart';
import 'entity.dart';

class Post {
  int id;
  List<Tag> tags;
  int created_at;
  int creator_id;
  String author;
  int change;
  String source;
  int score;
  String md5;
  int file_size;
  String file_url;
  bool is_shown_in_index;
  String preview_url;
  int preview_width;
  int preview_height;
  int actual_preview_width;
  int actual_preview_height;
  String sample_url;
  int sample_width;
  int sample_height;
  int sample_file_size;
  String jpeg_url;
  int jpeg_width;
  int jpeg_height;
  int jpeg_file_size;
  Rating rating;
  bool has_children;
  int parent_id;
  String status;
  int width;
  int height;
  bool is_held;
  String frames_pending_string;
  List frames_pending;
  String frames_string;
  List frames;
  String sample_local_url;
  String preview_local_url;
  String jpeg_local_url;
  String file_local_url;
  int operate_time;

  Post(
      {this.id,
      this.tags,
      this.created_at,
      this.creator_id,
      this.author,
      this.change,
      this.source,
      this.score,
      this.md5,
      this.file_size,
      this.file_url,
      this.is_shown_in_index,
      this.preview_url,
      this.preview_width,
      this.preview_height,
      this.actual_preview_width,
      this.actual_preview_height,
      this.sample_url,
      this.sample_width,
      this.sample_height,
      this.sample_file_size,
      this.jpeg_url,
      this.jpeg_width,
      this.jpeg_height,
      this.jpeg_file_size,
      this.rating,
      this.has_children,
      this.parent_id,
      this.status,
      this.width,
      this.height,
      this.is_held,
      this.frames_pending_string,
      this.frames_pending,
      this.frames_string,
      this.frames,
      this.sample_local_url,
      this.preview_local_url,
      this.jpeg_local_url,
      this.file_local_url});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tags = stringToTags(json['tags']);
    created_at = json['created_at'];
    creator_id = json['creator_id'];
    author = json['author'];
    change = json['change'];
    source = json['source'];
    score = json['score'];
    md5 = json['md5'];
    file_size = json['file_size'];
    file_url = json['file_url'];
    is_shown_in_index = json['is_shown_in_index'];
    preview_url = json['preview_url'];
    preview_width = json['preview_width'];
    preview_height = json['preview_height'];
    actual_preview_width = json['actual_preview_width'];
    actual_preview_height = json['actual_preview_height'];
    sample_url = json['sample_url'];
    sample_width = json['sample_width'];
    sample_height = json['sample_height'];
    sample_file_size = json['sample_file_size'];
    jpeg_url = json['jpeg_url'];
    jpeg_width = json['jpeg_width'];
    jpeg_height = json['jpeg_height'];
    jpeg_file_size = json['jpeg_file_size'];
    rating = capitalToRating(json['rating']);
    has_children = json['has_children'];
    parent_id = json['parent_id'];
    status = json['status'];
    width = json['width'];
    height = json['height'];
    is_held = json['is_held'];
    frames_pending_string = json['frames_pending_string'];
    frames_pending = json['frames_pending'];
    frames_string = json['frames_string'];
    frames = json['frames'];
  }

  Post.fromSql(Map<String, dynamic> sql) {
    id = sql['id'];
    tags = stringToTags(sql['tags']);
    created_at = sql['created_at'];
    creator_id = sql['creator_id'];
    author = sql['author'];
    change = sql['change'];
    source = sql['source'];
    score = sql['score'];
    md5 = sql['md5'];
    file_size = sql['file_size'];
    file_url = sql['file_url'];
    is_shown_in_index = intToBool(sql['is_shown_in_index']);
    preview_url = sql['preview_url'];
    preview_width = sql['preview_width'];
    preview_height = sql['preview_height'];
    actual_preview_width = sql['actual_preview_width'];
    actual_preview_height = sql['actual_preview_height'];
    sample_url = sql['sample_url'];
    sample_width = sql['sample_width'];
    sample_height = sql['sample_height'];
    sample_file_size = sql['sample_file_size'];
    jpeg_url = sql['jpeg_url'];
    jpeg_width = sql['jpeg_width'];
    jpeg_height = sql['jpeg_height'];
    jpeg_file_size = sql['jpeg_file_size'];
    rating = stringToRating(sql['rating']);
    has_children = intToBool(sql['has_children']);
    parent_id = sql['parent_id'];
    status = sql['status'];
    width = sql['width'];
    height = sql['height'];
    is_held = intToBool(sql['is_held']);
    frames_pending_string = sql['frames_pending_string'];
    frames_pending = stringToList(sql['frames_pending']);
    frames_string = sql['frames_string'];
    frames = stringToList(sql['frames']);
    sample_local_url = sql['sample_local_url'];
    preview_local_url = sql['preview_local_url'];
    jpeg_local_url = sql['jpeg_local_url'];
    file_local_url = sql['file_local_url'];
    operate_time = sql['operate_time'];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'tags': tags,
      'created_at': created_at,
      'creator_id': creator_id,
      'author': author,
      'change': change,
      'source': source,
      'score': score,
      'md5': md5,
      'file_size': file_size,
      'file_url': file_url,
      'is_shown_in_index': is_shown_in_index,
      'preview_url': preview_url,
      'preview_width': preview_width,
      'preview_height': preview_height,
      'actual_preview_width': actual_preview_width,
      'actual_preview_height': actual_preview_height,
      'sample_url': sample_url,
      'sample_width': sample_width,
      'sample_height': sample_height,
      'sample_file_size': sample_file_size,
      'jpeg_url': jpeg_url,
      'jpeg_width': jpeg_width,
      'jpeg_height': jpeg_height,
      'jpeg_file_size': jpeg_file_size,
      'rating': rating,
      'has_children': has_children,
      'parent_id': parent_id,
      'status': status,
      'width': width,
      'height': height,
      'is_held': is_held,
      'frames_pending_string': frames_pending_string,
      'frames_pending': frames_pending,
      'frames_string': frames_string,
      'frames': frames,
    };
  }

  Map<String, dynamic> toSql() {
    return <String, dynamic>{
      'id': id,
      'tags': tagsToString(tags),
      'created_at': created_at,
      'creator_id': creator_id,
      'author': author,
      'change': change,
      'source': source,
      'score': score,
      'md5': md5,
      'file_size': file_size,
      'file_url': file_url,
      'is_shown_in_index': boolToInt(is_shown_in_index),
      'preview_url': preview_url,
      'preview_width': preview_width,
      'preview_height': preview_height,
      'actual_preview_width': actual_preview_width,
      'actual_preview_height': actual_preview_height,
      'sample_url': sample_url,
      'sample_width': sample_width,
      'sample_height': sample_height,
      'sample_file_size': sample_file_size,
      'jpeg_url': jpeg_url,
      'jpeg_width': jpeg_width,
      'jpeg_height': jpeg_height,
      'jpeg_file_size': jpeg_file_size,
      'rating': ratingToString(rating),
      'has_children': boolToInt(has_children),
      'parent_id': parent_id,
      'status': status,
      'width': width,
      'height': height,
      'is_held': boolToInt(is_held),
      'frames_pending_string': frames_pending_string,
      'frames_pending': listToString(frames_pending),
      'frames_string': frames_string,
      'frames': listToString(frames),
      'sample_local_url': sample_local_url,
      'preview_local_url': preview_local_url,
      'jpeg_local_url': jpeg_local_url,
      'file_local_url': file_local_url,
      'operate_time': operate_time,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  bool operator ==(other) => this.id == other.id;
}

String tagsToString(List<Tag> tags) {
  return tags.map((Tag tag) => tag.name).toList().join(' ');
}

List<Tag> stringToTags(String tags) {
  return tags.split(' ').map((String item) => Tag(name: item)).toList();
}

class DatePost {
  final DateTime date;
  final List<Post> posts;

  DatePost({@required this.date, @required this.posts});
}

enum Rating { safe, questionable, explicit }

String ratingToString(Rating rating) {
  switch (rating) {
    case Rating.safe:
      return 'Safe';
    case Rating.questionable:
      return 'Questionable';
    case Rating.explicit:
      return 'Explicit';
    default:
      return 'Safe';
  }
}

Rating stringToRating(String rating) {
  switch (rating) {
    case 'Safe':
      return Rating.safe;
    case 'Questionable':
      return Rating.questionable;
    case 'Explicit':
      return Rating.explicit;
    default:
      return Rating.safe;
  }
}

Rating capitalToRating(String rating) {
  switch (rating) {
    case 's':
      return Rating.safe;
    case 'q':
      return Rating.questionable;
    case 'e':
      return Rating.explicit;
    default:
      return Rating.safe;
  }
}

enum PostMode { latest, popular, random }

String postModeToString(PostMode mode) {
  switch (mode) {
    case PostMode.latest:
      return 'latest';
    case PostMode.popular:
      return 'popular';
    case PostMode.random:
      return 'random';
    default:
      return '';
  }
}

PostMode stringToPostMode(String mode) {
  switch (mode) {
    case 'popular':
      return PostMode.popular;
    case 'random':
      return PostMode.random;
    case 'latest':
    default:
      return PostMode.latest;
  }
}

enum PopularType { day, week, month }

HeaderType popularTypeToHeaderType(PopularType type) {
  switch (type) {
    case PopularType.day:
      return HeaderType.day;
    case PopularType.week:
      return HeaderType.week;
    case PopularType.month:
      return HeaderType.month;
    default:
      return HeaderType.day;
  }
}

String popularTypeToString(PopularType type) {
  switch (type) {
    case PopularType.day:
      return 'day';
    case PopularType.week:
      return 'week';
    case PopularType.month:
      return 'month';
    default:
      return '';
  }
}

PopularType stringToPopularType(String type) {
  switch (type) {
    case 'day':
      return PopularType.day;
    case 'week':
      return PopularType.week;
    case 'month':
      return PopularType.month;
    default:
      return PopularType.day;
  }
}

class PostTask {
  String task_id;
  int id;
  PostType postType;
  String local_url;
  int operate_time;

  PostTask({this.task_id, this.id, this.postType, this.local_url});

  PostTask.fromJson(Map<String, dynamic> json) {
    task_id = json['task_id'];
    id = json['id'];
    postType = stringToPostType(json['post_type']);
    local_url = json['local_url'];
  }

  PostTask.fromSql(Map<String, dynamic> sql) {
    task_id = sql['task_id'];
    id = sql['id'];
    postType = stringToPostType(sql['post_type']);
    local_url = sql['local_url'];
    operate_time = sql['operate_time'];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'task_id': task_id,
      'id': id,
      'post_type': postTypeToString(postType),
      'local_url': local_url,
    };
  }

  Map<String, dynamic> toSql() {
    return <String, dynamic>{
      'task_id': task_id,
      'id': id,
      'post_type': postTypeToString(postType),
      'local_url': local_url,
      'operate_time': operate_time,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  bool operator ==(other) => this.task_id == other.task_id;
}

enum PostType { preview, sample, jpeg, file }

String postTypeToString(PostType postType) {
  switch (postType) {
    case PostType.preview:
      return 'preview';
    case PostType.sample:
      return 'sample';
    case PostType.jpeg:
      return 'jpeg';
    case PostType.file:
      return 'file';
    default:
      return 'preview';
  }
}

PostType stringToPostType(String postType) {
  switch (postType) {
    case 'preview':
      return PostType.preview;
    case 'sample':
      return PostType.sample;
    case 'jpeg':
      return PostType.jpeg;
    case 'file':
      return PostType.file;
    default:
      return PostType.preview;
  }
}

String postTypeToUrl(PostType postType, Post post) {
  switch (postType) {
    case PostType.preview:
      return post.preview_local_url;
    case PostType.sample:
      return post.sample_local_url;
    case PostType.jpeg:
      return post.jpeg_local_url;
    case PostType.file:
      return post.file_local_url;
    default:
      return post.preview_local_url;
  }
}
