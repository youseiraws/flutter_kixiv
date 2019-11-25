import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scoped_model/scoped_model.dart';

import '../config/config.dart';
import '../entity/entity.dart';
import '../helper/helper.dart';
import '../util/util.dart';

class BaseModel extends Model {
  BaseModel() {
    initConnectivity();
    requestPermissions();
    TagManagement();
    Api();
  }

  initConnectivity() async {
    _handleConnectivityResult(await Connectivity().checkConnectivity());

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _handleConnectivityResult(result);
    });
  }

  requestPermissions() {
    requestPermission(PermissionGroup.storage);
  }

  _handleConnectivityResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        bus.fire(ConnectivityChangedEvent(ConnectivityStatus.connected));
        break;
      case ConnectivityResult.none:
        bus.fire(ConnectivityChangedEvent(ConnectivityStatus.disconnected));
        Fluttertoast.showToast(msg: NO_CONNECTIVITY);
        break;
    }
  }
}

class TagManagement {
  List<Tag> tags = <Tag>[];

  TagManagement() {
    _postRequestedHandler();
    _tagRequestedHandler();
  }

  _postRequestedHandler() async {
    bus.on<PostRequestedEvent>().listen((PostRequestedEvent event) async {
      for (int i = 0; i < event.posts.length; i++) {
        for (int j = 0; j < event.posts[i].tags.length; j++) {
          int index = tags.indexOf(event.posts[i].tags[j]);
          if (index == -1) {
            List<Tag> response = <Tag>[];
            String name = event.posts[i].tags[j].name;
            response = await TagHelper().isExpired(name: name)
                ? await Api.tag(name: name)
                : <Tag>[await TagHelper().query(name: name)];
            _combine(response);
            index = tags.indexOf(event.posts[i].tags[j]);
            if (index != -1) {
              event.posts[i].tags[j] = tags[index];
            }
          } else {
            event.posts[i].tags[j] = tags[index];
          }
        }
      }
    });
  }

  _tagRequestedHandler() {
    bus.on<TagRequestedEvent>().listen((TagRequestedEvent event) {
      _combine(event.tags);
    });
  }

  _combine(List<Tag> tags) {
    for (Tag tag in tags) {
      if (!this.tags.contains(tag)) {
        this.tags.add(tag);
      }
    }
  }
}

enum ConnectivityStatus { connected, disconnected }
