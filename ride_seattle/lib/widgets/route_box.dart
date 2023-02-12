import 'package:flutter/material.dart';

import '../styles/tile_style.dart';

class RouteBox extends StatelessWidget {
  final String text;
  const RouteBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      constraints: const BoxConstraints(
        minWidth: 40,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1.5,
        ),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TileStyle.routeNumberStyle(),
          ),
        ),
      ),
    );
  }
}
