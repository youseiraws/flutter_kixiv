import 'package:flutter/material.dart';

import '../../entity/entity.dart';

class PopularHeader extends StatelessWidget {
  final PopularType type;
  final changeType;

  PopularHeader({@required this.type, @required this.changeType});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 18.0),
        PopupMenuButton(
          offset: Offset(0, 48.0),
          elevation: 0.0,
          child: Chip(label: Text(popularTypeToString(type))),
          onSelected: (PopularType type) {
            changeType(type);
          },
          itemBuilder: (context) {
            return PopularType.values.map((PopularType type) {
              return PopupMenuItem<PopularType>(
                value: type,
                child: Text(popularTypeToString(type)),
              );
            }).toList();
          },
        )
      ],
    );
  }
}
