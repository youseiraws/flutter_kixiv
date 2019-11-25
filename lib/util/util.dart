import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

export 'api.dart';
export 'event.dart';

PermissionHandler handler = PermissionHandler();

requestPermission(PermissionGroup group) async {
  if (Platform.isAndroid) {
    PermissionStatus status = await handler.checkPermissionStatus(group);
    if (status != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions = await handler.requestPermissions([group]);
      if (permissions[group] == PermissionStatus.granted) {
        return true;
      }
    } else {
      return true;
    }
  } else {
    return true;
  }
  return false;
}
