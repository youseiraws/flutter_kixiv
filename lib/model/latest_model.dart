import 'package:scoped_model/scoped_model.dart';

import '../entity/entity.dart';
import '../util/util.dart';
import 'base_model.dart';

class LatestModel extends Model {
  num _count = double.infinity;
  DateTime _date = DateTime.now().toUtc();
  List<DatePost> _latests = <DatePost>[];

  bool _isConnected = true;
  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _isLoaded = false;

  LatestModel() {
    _initConnectivityListener();
  }

  num get count => _count;

  List<DatePost> get latests => _latests;

  bool get isRefreshing => _isRefreshing;

  bool get isLoaded => _isLoaded;

  _initConnectivityListener() {
    bus.on<ConnectivityChangedEvent>().listen((ConnectivityChangedEvent event) {
      _isConnected = event.status == ConnectivityStatus.connected;
      if (event.status == ConnectivityStatus.connected) {
        refreshLatest();
      }
    });
  }

  loadLatest({bool isLoadInImagePage = false}) async {
    if (!_isConnected || _isLoading || _isRefreshing) {
      return;
    }
    _isLoading = true;
    _isLoaded = false;
    List<Post> datas = await Api.post(date: _date, page: -1);
    if (isLoadInImagePage) {
      List<Post> posts = <Post>[];
      _latests.map((DatePost latest) => posts.addAll(latest.posts)).toList();
      bus.fire(PostRefreshedEvent(posts, _count));
    }
    if (datas.isNotEmpty) {
      _latests.add(DatePost(date: _date, posts: datas));
    } else {
      List<Post> posts = <Post>[];
      _latests.map((DatePost latest) => posts.addAll(latest.posts)).toList();
      _count = posts.length;
      _isLoaded = true;
    }
    _date = _date.subtract(Duration(days: 1));
    _isLoading = false;
    notifyListeners();
  }

  refreshLatest() async {
    if (!_isConnected || _isLoading || _isRefreshing) {
      return;
    }
    _isRefreshing = true;
    _isLoaded = false;
    notifyListeners();
    if (_latests.isEmpty) {
      await loadLatest();
    } else {
      DateTime _curDate = DateTime.now().toUtc();
      int dayDiff = _curDate.day - _latests[0].date.day;
      for (int i = 0; i <= dayDiff; i++) {
        List<Post> posts = await Api.post(date: _curDate, page: -1);
        if (posts.isNotEmpty) {
          if (dayDiff != i) {
            _latests.insert(i, DatePost(date: _curDate, posts: posts));
          } else {
            _latests[i] = DatePost(date: _curDate, posts: posts);
          }
        } else {
          List<Post> posts = <Post>[];
          _latests.map((DatePost latest) => posts.addAll(latest.posts)).toList();
          _count = posts.length;
          _isLoaded = true;
        }
        _curDate = _curDate.subtract(Duration(days: 1));
      }
    }
    _isRefreshing = false;
    notifyListeners();
  }
}
