import 'package:flutter/material.dart';
import 'package:ride_seattle/styles/tile_style.dart';

class RouteName extends StatelessWidget {
  final String text;
  const RouteName({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: TileStyle.routeNameStyle(),
          ),
        ),
      ),
    );
  }
}