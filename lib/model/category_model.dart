import 'package:scoped_model/scoped_model.dart';

import '../entity/entity.dart';
import '../util/util.dart';
import 'base_model.dart';

class CategoryModel extends Model {
  int _tag = 0;
  int _page = 1;
  int _limit = 15;
  num _count = double.infinity;
  String _name = '';
  List<Tag> _tags = <Tag>[];
  List<Tag> _hintTags = <Tag>[];
  List<Category> _categories = <Category>[];
  List<String> _name_partterns = <String>[];
  TagType _type = TagType.any;
  TagOrder _order = TagOrder.count;

  bool _isConnected = true;
  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _isReloading = false;
  bool _isSearching = false;
  bool _isLoaded = false;

  CategoryModel() {
    _initConnectivityListener();
  }

  num get count => _count;

  List<Category> get categories => _categories;

  TagType get type => _type;

  TagOrder get order => _order;

  List<Tag> get hintTags => _hintTags;

  List<String> get name_partterns => _name_partterns;

  bool get isRefreshing => _isRefreshing;

  bool get isLoaded => _isLoaded;

  _initConnectivityListener() {
    bus.on<ConnectivityChangedEvent>().listen((ConnectivityChangedEvent event) {
      _isConnected = event.status == ConnectivityStatus.connected;
      if (event.status == ConnectivityStatus.connected) {
        refreshCategory();
      }
    });
  }

  changeType(TagType type) async {
    if (_type == type) {
      return;
    }
    _type = type;
    notifyListeners();
    await _reloadCategory();
  }

  changeOrder(TagOrder order) async {
    if (_order == order) {
      return;
    }
    _order = order;
    notifyListeners();
    await _reloadCategory();
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

  changeNameParttern(String tag, bool isAdd) async {
    if (isAdd && _name_partterns.contains(tag) || !isAdd && !_name_partterns.contains(tag)) {
      return;
    }
    isAdd ? _name_partterns.add(tag) : _name_partterns.remove(tag);
    notifyListeners();
    await _reloadCategory();
  }

  loadCategory() async {
    if (!_isConnected || _isLoading || _isRefreshing || _isReloading) {
      return;
    }
    _isLoading = true;
    await _searchCategory();
    _isLoading = false;
    notifyListeners();
  }

  refreshCategory() async {
    if (_isConnected || _isLoading || _isRefreshing || _isReloading) {
      return;
    }
    _isRefreshing = true;
    notifyListeners();
    _init();
    await _searchCategory();
    _isRefreshing = false;
    notifyListeners();
  }

  _reloadCategory() async {
    Api.cancelCategory();
    Api.cancelTag();
    _isReloading = true;
    _init();
    await _searchCategory();
    _isReloading = false;
    notifyListeners();
  }

  _init() {
    _categories.clear();
    _tags.clear();
    _tag = 0;
    _page = 1;
  }

  _searchCategory() async {
    if (_tags.isNotEmpty && _tag < _tags.length) {
      Category category = await Api.category(tag: _tags[_tag]);
      if (category != null) {
        _categories.add(category);
        _tag++;
      } else if (_tags.isNotEmpty) {
        _tags.removeAt(_tag);
      }
    } else {
      _count = double.infinity;
      _isLoaded = false;
      List<Tag> tags = await Api.tag(
          page: _page, type: _type, order: _order, name_parttern: _name_partterns, method: HttpMethod.FETCH);
      if (tags.isNotEmpty) {
        _tags.addAll(tags);
        _page++;
      } else {
        _count = _categories.length;
        _isLoaded = true;
      }
    }
  }

  _searchTag() async {
    List<Tag> tags = await Api.tag(limit: _limit, name: _name, method: HttpMethod.POST);
    _hintTags.addAll(tags);
  }
}
