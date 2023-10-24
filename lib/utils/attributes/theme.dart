import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lighttheme = ThemeData(
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 1,
      titleTextStyle:  TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontSize: 19,
      )
    ),
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: Colors.blue,
      secondary: Colors.deepPurple,


    ),
  );

  static ThemeData Darktheme = ThemeData(
    useMaterial3: true,
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        titleTextStyle:  TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontSize: 19,
        )
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
      secondary: Colors.red,
    ),
  );
}
