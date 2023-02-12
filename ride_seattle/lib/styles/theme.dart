import 'package:flutter/material.dart';

class RideSeattleTheme {
  static ThemeData theme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Colors.lightBlue,
        secondary: Colors.blue,
        background: Colors.lightBlue,
      ),
    );
  }
}
