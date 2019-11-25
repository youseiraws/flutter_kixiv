import 'package:scoped_model/scoped_model.dart';

import '../entity/entity.dart';
import '../util/util.dart';
import 'base_model.dart';

class TagModel extends Model {
  int _page = 1;
  num _count = double.infinity;
  Tag _tag;
  PostMode _mode = PostMode.latest;
  List<Post> _posts = <Post>[];

  bool _isConnected = true;
  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _isReloading = false;
  bool _isLoaded = false;

  TagModel() {
    _initConnectivityListener();
  }

  num get count => _count;

  Tag get tag => _tag;

  PostMode get mode => _mode;

  List<Post> get posts => _posts;

  bool get isRefreshing => _isRefreshing;

  bool get isLoaded => _isLoaded;

  _initConnectivityListener() {
    bus.on<ConnectivityChangedEvent>().listen((ConnectivityChangedEvent event) {
      _isConnected = event.status == ConnectivityStatus.connected;
    });
  }

  initPost(Tag tag) {
    _tag = tag;
    notifyListeners();
  }

  changeMode(PostMode mode) async {
    if (_mode == mode) {
      return;
    }
    _mode = mode;
    notifyListeners();
    await _reloadPost();
  }

  loadPost({bool isLoadInImagePage = false}) async {
    if (!_isConnected || _isLoading || _isRefreshing || _isReloading) {
      return;
    }
    _isLoading = true;
    await _searchPost();
    if (isLoadInImagePage) {
      bus.fire(PostRefreshedEvent(_posts, _count));
    }
    _isLoading = false;
    notifyListeners();
  }

  refreshPost() async {
    if (!_isConnected || _isLoading || _isRefreshing || _isReloading) {
      return;
    }
    _isRefreshing = true;
    notifyListeners();
    _init();
    await _searchPost();
    _isRefreshing = false;
    notifyListeners();
  }

  _reloadPost() async {
    Api.cancelPost();
    Api.cancelRandom();
    _isReloading = true;
    _init();
    await _searchPost();
    _isReloading = false;
    notifyListeners();
  }

  _init() {
    _page = 1;
    _posts.clear();
  }

  _searchPost() async {
    _isLoaded = false;
    List<Post> datas = <Post>[];
    switch (mode) {
      case PostMode.latest:
        datas = await Api.post(page: _page, tags: <String>[_tag?.name]);
        break;
      case PostMode.popular:
        datas = await Api.post(page: _page, tags: <String>['order:score', _tag?.name]);
        break;
      case PostMode.random:
        datas = await Api.random(page: _page, tags: <String>[_tag?.name]);
        break;
    }
    if (datas.isNotEmpty) {
      _posts.addAll(datas);
      _page++;
    } else {
      _count = _posts.length;
      _isLoaded = true;
    }
  }
}
