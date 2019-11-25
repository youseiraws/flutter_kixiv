import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';

import '../entity/entity.dart';
import '../helper/helper.dart';
import 'util.dart';

class Api {
  static const String BASEURL = 'https://konachan.com';
  static Map<String, dynamic> headerMap = {'content-type': 'application/json; charset=utf-8'};
  static Dio dio = Dio(BaseOptions(baseUrl: BASEURL, headers: headerMap));
  static Map<String, CancelToken> tokenMap = <String, CancelToken>{
    'post': CancelToken(),
    'random': CancelToken(),
    'tag': CancelToken(),
    'category': CancelToken(),
    'popular': CancelToken()
  };

  static Future<List<Post>> post(
      {int limit,
      int page,
      List<String> tags,
      DateTime date,
      HttpMethod method = HttpMethod.GET,
      CancelToken token}) async {
    Map<String, dynamic> params = <String, dynamic>{};
    tags ??= <String>[];
    String tagsStr;

    if (limit != null) {
      params['limit'] = limit;
    }
    if (page != null) {
      params['page'] = page;
    }
    if (date != null) {
      tags.add('date:${DateFormat('yyyy-MM-dd').format(date)}');
    }
    if (tags != null && tags.length > 0) {
      tagsStr = tags.join('+');
    }
    if (tagsStr != null) {
      params['tags'] = tagsStr;
    }
    if (page == -1) {
      int index = 1;
      List<Post> responses = <Post>[];
      List<Post> res;
      do {
        params['page'] = index;
        res = await _post(params);
        if (res is List) {
          responses.addAll(res);
        }
        index++;
      } while (res is List<Post> && res.length > 0);
      return responses;
    }
    return await _post(params, method: method, token: (token == null ? tokenMap['post'] : token));
  }

  static cancelPost() {
    tokenMap['post'].cancel();
    tokenMap['post'] = CancelToken();
  }

  static Future<List<Post>> random(
      {int limit, int page, List<String> tags, HttpMethod method = HttpMethod.GET, CancelToken token}) async {
    if (tags != null) {
      tags.add('order:random');
    } else {
      tags = ['order:random'];
    }
    return post(tags: tags, page: page, limit: limit, token: (token == null ? tokenMap['random'] : token));
  }

  static cancelRandom() {
    tokenMap['random'].cancel();
    tokenMap['random'] = CancelToken();
  }

  static Future<List<Tag>> tag(
      {int limit,
      int page,
      TagType type = TagType.any,
      TagOrder order = TagOrder.count,
      int id,
      int after_id,
      String name,
      List<String> name_parttern,
      HttpMethod method = HttpMethod.POST,
      CancelToken token}) async {
    Map<String, dynamic> params = <String, dynamic>{};

    if (limit != null) {
      params['limit'] = limit;
    }
    if (page != null) {
      params['page'] = page;
    }
    if (order != null) {
      params['order'] = tagOrderToString(order);
    }
    if (type != null) {
      params['type'] = tagTypeToInt(type);
    }
    if (id != null) {
      params['id'] = id;
    }
    if (after_id != null) {
      params['after_id'] = after_id;
    }
    if (name != null) {
      params['name'] = name;
    } else if (name_parttern != null) {
      params['name'] = '*${name_parttern.join('*')}*';
    }
    return await _tag(params, method: method, token: (token == null ? tokenMap['tag'] : token));
  }

  static cancelTag() {
    tokenMap['tag'].cancel();
    tokenMap['tag'] = CancelToken();
  }

  static Future<Category> category({Tag tag, CancelToken token}) async {
    List<Post> posts = await random(limit: 1, tags: [tag.name], token: (token == null ? tokenMap['category'] : token));
    if (posts.isNotEmpty) {
      return Category.fromJson({'cover': posts[0], 'tag': tag});
    }
    return null;
  }

  static cancelCategory() {
    tokenMap['category'].cancel();
    tokenMap['category'] = CancelToken();
  }

  static Future<List<Post>> popular(PopularType type,
      {int day, int month, int year, HttpMethod method = HttpMethod.GET, CancelToken token}) async {
    Map<String, dynamic> params = <String, dynamic>{};
    if (day != null) {
      params['day'] = day;
    }
    if (month != null) {
      params['month'] = month;
    }
    if (year != null) {
      params['year'] = year;
    }
    return await _popular(params, type, method: method, token: (token == null ? tokenMap['popular'] : token));
  }

  static cancelPopular() {
    tokenMap['popular'].cancel();
    tokenMap['popular'] = CancelToken();
  }

  static Future<List<Post>> _post(Map<String, dynamic> params,
      {HttpMethod method = HttpMethod.GET, CancelToken token}) async {
    dynamic response;
    switch (method) {
      case HttpMethod.GET:
        List<String> querys = <String>[];
        params.forEach((key, value) {
          querys.add('$key=$value');
        });
        response = await doGet('/post.json?${querys.join('&')}', token: token);
        break;
      case HttpMethod.POST:
      default:
        response = await doPost('/post.json', params, token: token);
        break;
    }
    List<Post> result = <Post>[];
    if (response is List) {
      result = response.map((item) {
        return Post.fromJson(item);
      }).toList();
    }
    await PostHelper().synchronize(result);
    bus.fire(PostRequestedEvent(result));
    return result;
  }

  static Future<List<Tag>> _tag(Map<String, dynamic> params,
      {HttpMethod method = HttpMethod.POST, CancelToken token}) async {
    if (params.containsKey('id') && !(await TagHelper().isExpired(id: params['id']))) {
      return <Tag>[await TagHelper().query(id: params['id'])];
    }
    dynamic response;
    switch (method) {
      case HttpMethod.FETCH:
        response = await doGet('/tag', params: params, token: token);
        break;
      case HttpMethod.GET:
        List<String> querys = <String>[];
        params.forEach((key, value) {
          querys.add('$key=$value');
        });
        response = await doGet('/tag.json?${querys.join('&')}', token: token);
        break;
      case HttpMethod.POST:
      default:
        response = await doPost('/tag.json', params, token: token);
        break;
    }
    List<Tag> result = <Tag>[];
    if (response is String) {
      Document document = parse(response);
      List<Element> trs = document.querySelectorAll('table.highlightable>tbody>tr');
      result = trs.map((tr) {
        List<Element> tds = tr.querySelectorAll('td');
        return Tag(
            id: int.parse(tds[3].children[0].attributes['href'].split('/').last),
            name: tds[1].children[1].text,
            count: int.parse(tds[0].text),
            type: stringToTagType(tds[2].text));
      }).toList();
    } else if (response is List) {
      result = response.map((item) {
        return Tag.fromJson(item);
      }).toList();
    }
    await TagHelper().insert(result);
    bus.fire(TagRequestedEvent(result));
    return result;
  }

  static Future<List<Post>> _popular(Map<String, dynamic> params, PopularType type,
      {HttpMethod method = HttpMethod.GET, CancelToken token}) async {
    dynamic response;
    String url;
    switch (type) {
      case PopularType.day:
        url = '/post/popular_by_day.json';
        break;
      case PopularType.week:
        url = '/post/popular_by_week.json';
        break;
      case PopularType.month:
        url = '/post/popular_by_month.json';
        break;
    }
    switch (method) {
      case HttpMethod.GET:
        response = await doGet(url, params: params, token: token);
        break;
      default:
        response = await doPost(url, params, token: token);
        break;
    }
    List<Post> result = <Post>[];
    if (response is List) {
      result = response.map((item) {
        return Post.fromJson(item);
      }).toList();
    }
    await PostHelper().synchronize(result);
    bus.fire(PostRequestedEvent(result));
    return result;
  }

  static Future doGet(String url, {Map<String, dynamic> params, CancelToken token}) async {
    Response response = await dio.get(url, queryParameters: params, cancelToken: token).catchError((err) {
      if (err is DioError) {
        return null;
      }
    });
    return response?.data;
  }

  static Future doPost(String url, Map<String, dynamic> params, {CancelToken token}) async {
    Response response = await dio.post(url, data: params, cancelToken: token).catchError((err) {
      if (err is DioError) {
        return null;
      }
    });
    return response?.data;
  }
}

enum HttpMethod { FETCH, GET, POST }
