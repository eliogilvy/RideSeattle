import 'package:flutter/material.dart';

import '../styles/tile_style.dart';

class RouteBox extends StatefulWidget {
  final String text;
  const RouteBox({super.key, required this.text, required this.maxW});
  final double maxW;

  @override
  State<RouteBox> createState() => _RouteBoxState();
}

class _RouteBoxState extends State<RouteBox> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        key: const ValueKey("route_box"),
        constraints:
            BoxConstraints(maxHeight: 40, minWidth: 40, maxWidth: widget.maxW),
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
          child: Tooltip(
            message: widget.text,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
