import 'package:scoped_model/scoped_model.dart';

import '../entity/entity.dart';
import '../util/util.dart';
import 'base_model.dart';

class RandomModel extends Model {
  int _page = 1;
  int _limit = 15;
  num _count = double.infinity;
  List<Post> _randoms = <Post>[];
  String _name = '';
  List<Tag> _hintTags = <Tag>[];
  List<Tag> _tags = <Tag>[];

  bool _isConnected = true;
  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _isLoaded = false;
  bool _isSearching = false;

  RandomModel() {
    _initConnectivityListener();
  }

  num get count => _count;

  List<Post> get randoms => _randoms;

  List<Tag> get hintTags => _hintTags;

  List<Tag> get tags => _tags;

  bool get isRefreshing => _isRefreshing;

  bool get isLoaded => _isLoaded;

  _initConnectivityListener() {
    bus.on<ConnectivityChangedEvent>().listen((ConnectivityChangedEvent event) {
      _isConnected = event.status == ConnectivityStatus.connected;
      if (event.status == ConnectivityStatus.connected) {
        refreshRandom();
      }
    });
  }

  loadRandom({bool isLoadInImagePage = false}) async {
    if (!_isConnected || _isLoading || _isRefreshing) {
      return;
    }
    _isLoading = true;
    await _searchRandom();
    if (isLoadInImagePage) {
      bus.fire(PostRefreshedEvent(_randoms, _count));
    }
    _isLoading = false;
    notifyListeners();
  }

  refreshRandom() async {
    if (!_isConnected || _isLoading || _isRefreshing) {
      return;
    }
    _isRefreshing = true;
    notifyListeners();
    _init();
    await _searchRandom();
    _isRefreshing = false;
    notifyListeners();
  }

  changeName(String tag) async {
    if (tag == _name && _isSearching) {
      return;
    }
    _isSearching = true;
    _hintTags.clear();
    _name = tag;
    await _searchTag();
    _isSearching = false;
    notifyListeners();
  }

  changeTags(Tag tag, bool isAdd) async {
    if (isAdd && _tags.contains(tag) || !isAdd && !_tags.contains(tag)) {
      return;
    }
    isAdd ? _tags.add(tag) : _tags.remove(tag);
    notifyListeners();
    await refreshRandom();
  }

  _init() {
    _page = 1;
    _randoms.clear();
    _count = double.infinity;
  }

  _searchRandom() async {
    _isLoaded = false;
    List<Post> datas = await Api.random(
        page: _page,
        tags: _tags.map((Tag tag) {
          return tag.name;
        }).toList());
    if (datas.isNotEmpty) {
      _randoms.addAll(datas);
      _page++;
    } else {
      _count = _randoms.length;
      _isLoaded = true;
    }
  }

  _searchTag() async {
    List<Tag> tags = await Api.tag(limit: _limit, name: _name, method: HttpMethod.POST);
    _hintTags.addAll(tags);
  }
}
