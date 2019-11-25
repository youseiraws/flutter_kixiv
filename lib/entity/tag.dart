import 'dart:ui';

import 'entity.dart';

class Tag {
  int id;
  String name;
  int count;
  TagType type;
  bool ambiguous;
  int operate_time;

  Tag({this.id, this.name, this.count, this.type, this.ambiguous});

  Tag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    count = json['count'];
    type = intToTagType(json['type']);
    ambiguous = json['ambiguous'];
  }

  Tag.fromSql(Map<String, dynamic> sql) {
    id = sql['id'];
    name = sql['name'];
    count = sql['count'];
    type = intToTagType(sql['type']);
    ambiguous = intToBool(sql['ambiguous']);
    operate_time = sql['operate_time'];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'count': count,
      'type': tagTypeToInt(type),
      'ambiguous': ambiguous,
    };
  }

  Map<String, dynamic> toSql() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'count': count,
      'type': tagTypeToInt(type),
      'ambiguous': boolToInt(ambiguous),
      'operate_time': operate_time,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  bool operator ==(other) => this.name == other.name;
}

class StarredTag {
  int id;
  int operate_time;

  StarredTag({this.id});

  StarredTag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    operate_time = json['operate_time'];
  }

  StarredTag.fromSql(Map<String, dynamic> sql) {
    id = sql['id'];
    operate_time = sql['operate_time'];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'operate_time': operate_time,
    };
  }

  Map<String, dynamic> toSql() {
    return <String, dynamic>{
      'id': id,
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

class Category {
  Post cover;
  Tag tag;

  Category({this.cover, this.tag});

  Category.fromJson(Map<String, dynamic> json) {
    cover = json['cover'];
    tag = json['tag'];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'cover': cover, 'tag': tag};
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

enum TagOrder { date, count, name }

tagOrderToString(TagOrder order) {
  switch (order) {
    case TagOrder.date:
      return 'date';
    case TagOrder.count:
      return 'count';
    case TagOrder.name:
      return 'name';
  }
}

stringToTagOrder(String order) {
  switch (order) {
    case 'date':
      return TagOrder.date;
    case 'count':
      return TagOrder.count;
    case 'name':
      return TagOrder.name;
  }
}

enum TagType { any, general, artist, copyright, character, style, circle }

dynamic tagTypeToInt(TagType type) {
  switch (type) {
    case TagType.general:
      return 0;
    case TagType.artist:
      return 1;
    case TagType.copyright:
      return 3;
    case TagType.character:
      return 4;
    case TagType.style:
      return 5;
    case TagType.circle:
      return 6;
    case TagType.any:
    default:
      return '';
  }
}

TagType intToTagType(int type) {
  switch (type) {
    case 0:
      return TagType.general;
    case 1:
      return TagType.artist;
    case 3:
      return TagType.copyright;
    case 4:
      return TagType.character;
    case 5:
      return TagType.style;
    case 6:
      return TagType.circle;
    default:
      return TagType.any;
  }
}

TagType stringToTagType(String type) {
  switch (type) {
    case 'general':
      return TagType.general;
    case 'artist':
      return TagType.artist;
    case 'copyright':
      return TagType.copyright;
    case 'character':
      return TagType.character;
    case 'style':
      return TagType.style;
    case 'circle':
      return TagType.circle;
    default:
      return TagType.any;
  }
}

String tagTypeToString(TagType type) {
  switch (type) {
    case TagType.general:
      return 'general';
    case TagType.artist:
      return 'artist';
    case TagType.copyright:
      return 'copyright';
    case TagType.character:
      return 'character';
    case TagType.style:
      return 'style';
    case TagType.circle:
      return 'circle';
    case TagType.any:
    default:
      return 'any';
  }
}

Color tagTypeToColor(TagType type) {
  switch (type) {
    case TagType.general:
      return Color(0xffffaaae);
    case TagType.artist:
      return Color(0xffcccc00);
    case TagType.copyright:
      return Color(0xffdd00dd);
    case TagType.character:
      return Color(0xff00aa00);
    case TagType.style:
      return Color(0xffff2020);
    case TagType.circle:
      return Color(0xff00bbbb);
    case TagType.any:
    default:
      return Color(0xff000000);
  }
}
