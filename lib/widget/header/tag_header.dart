import 'package:flutter/material.dart';

import '../../entity/entity.dart';

class TagHeader extends StatelessWidget {
  final PostMode mode;
  final changeMode;

  TagHeader({@required this.mode, @required this.changeMode});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 18.0),
        PopupMenuButton(
          offset: Offset(0, 48.0),
          elevation: 0.0,
          child: Chip(label: Text(postModeToString(mode))),
          onSelected: (PostMode mode) {
            changeMode(mode);
          },
          itemBuilder: (context) {
            return PostMode.values.map((PostMode mode) {
              return PopupMenuItem<PostMode>(
                value: mode,
                child: Text(postModeToString(mode)),
              );
            }).toList();
          },
        )
      ],
    );
  }
}
