import 'package:flutter/material.dart';

class LatestHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 20,
                itemBuilder: (context, index) {
                  return Chip(
                    label: Text(index.toString()),
                  );
                }),

        ),
        SizedBox(
          child: IconButton(icon: Icon(Icons.search), onPressed: () {}),
        )
      ],
    );
  }
}
