export 'post.dart';
export 'tag.dart';

int boolToInt(bool b) {
  return b != null ? b ? 1 : 0 : 0;
}

bool intToBool(int i) {
  return i != 0;
}

String listToString(List l) {
  if (l.isEmpty) {
    return '';
  }
  return l.join(' ');
}

List stringToList(String s) {
  if (s.isEmpty) {
    return [];
  }
  return s.split(' ');
}
