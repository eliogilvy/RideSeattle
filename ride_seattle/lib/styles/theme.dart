import 'package:flutter/material.dart';

class RideSeattleTheme {
  static ThemeData theme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue[900],
      primaryColorLight: Colors.blue[100],
      primaryColorDark: Colors.blue[800],
      canvasColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.blue[50],
      dividerColor: Colors.grey[400],
      secondaryHeaderColor: Colors.blue[200],
      dialogBackgroundColor: Colors.white,
      indicatorColor: Colors.blue[900],
      hintColor: Colors.grey[400],
      buttonTheme: const ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontFamily: 'route',
          fontSize: 18,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'route',
          fontSize: 30,
        ),
      ),
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
          fontFamily: 'route',
          fontSize: 24,
        )
      ),
      iconTheme: const IconThemeData(
        color: Colors.blue,
      )
    );
  }
}
