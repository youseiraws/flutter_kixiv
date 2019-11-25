import 'package:scoped_model/scoped_model.dart';

import '../entity/entity.dart';
import '../util/util.dart';
import 'base_model.dart';

class PopularModel extends Model {
  num _count = double.infinity;
  PopularType _type = PopularType.day;
  DateTime _date;

  List<DatePost> _populars = <DatePost>[];

  bool _isConnected = true;
  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _isReloading = false;
  bool _isLoaded = false;

  PopularModel() {
    _initConnectivityListener();
    _initDate();
  }

  num get count => _count;

  PopularType get type => _type;

  List<DatePost> get populars => _populars;

  bool get isRefreshing => _isRefreshing;

  bool get isLoaded => _isLoaded;

  _initConnectivityListener() {
    bus.on<ConnectivityChangedEvent>().listen((ConnectivityChangedEvent event) {
      _isConnected = event.status == ConnectivityStatus.connected;
      if (event.status == ConnectivityStatus.connected) {
        refreshPopular();
      }
    });
  }

  changeType(PopularType type) async {
    if (_type == type) {
      return;
    }
    _type = type;
    notifyListeners();
    await _reloadPopular();
  }

  loadPopular({bool isLoadInImagePage = false}) async {
    if (!_isConnected || _isLoading || _isRefreshing || _isReloading) {
      return;
    }
    _isLoading = true;
    await _searchPopular();
    if (isLoadInImagePage) {
      List<Post> posts = <Post>[];
      _populars.map((DatePost popular) => posts.addAll(popular.posts)).toList();
      bus.fire(PostRefreshedEvent(posts, _count));
    }
    _isLoading = false;
    notifyListeners();
  }

  refreshPopular() async {
    if (!_isConnected || _isLoading || _isRefreshing || _isReloading) {
      return;
    }
    _isRefreshing = true;
    notifyListeners();
    _init();
    await _searchPopular();
    _isRefreshing = false;
    notifyListeners();
  }

  _reloadPopular() async {
    Api.cancelPopular();
    _isReloading = true;
    _init();
    await _searchPopular();
    _isReloading = false;
    notifyListeners();
  }

  _init() {
    _initDate();
    _populars.clear();
    _count = double.infinity;
  }

  _initDate() {
    DateTime now = DateTime.now().toUtc().subtract(Duration(days: 1));
    switch (_type) {
      case PopularType.day:
        _date = now;
        break;
      case PopularType.week:
        _date = now.subtract(Duration(days: now.weekday - DateTime.monday));
        break;
      case PopularType.month:
        _date = now.subtract(Duration(days: now.day - 1));
        break;
    }
  }

  _searchPopular() async {
    _isLoaded = false;
    List<Post> datas = <Post>[];
    datas = await Api.popular(_type, day: _date.day, month: _date.month, year: _date.year);
    if (datas.isNotEmpty) {
      _populars.add(DatePost(date: _date, posts: datas));
    } else {
      List<Post> posts = <Post>[];
      _populars.map((DatePost popular) => posts.addAll(popular.posts)).toList();
      _count = posts.length;
      _isLoaded = true;
    }
    switch (_type) {
      case PopularType.day:
        _date = _date.subtract(Duration(days: 1));
        break;
      case PopularType.week:
        _date = _date.subtract(Duration(days: 7));
        break;
      case PopularType.month:
        _date = _prevMonth(_date);
        break;
    }
  }

  DateTime _prevMonth(DateTime date) {
    DateTime result;
    if (date.month == DateTime.january) {
      result = DateTime(date.year - 1, DateTime.december);
    } else {
      result = DateTime(date.year, date.month - 1);
    }
    return result;
  }
}
