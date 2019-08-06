import 'package:flutter/material.dart';

// Optional Classes for switching themes.
class DarkTheme {
  // Scaffold (AppBar, Home) Colors.
  static Color appBarColor = Color(0xff963329);
  static Color homeColor = Color(0xff262a30);

  // Navigation Bar Colors.
  static Color navigationBarColor = Color(0xff262a30);
  static Color activeButtonColor = Colors.grey[100];

  // Error Colors.
  static Color errorProgressColor = Color(0xff963329);
  static Color errorTextColor = Colors.white24;

  // [Browse Page] Movie Card Colors.
  static Color movieCardColor = Color(0xff181a1c);
  static Color movieTitleColor = Colors.white;
  static Color movieDescriptionColor = Colors.white70;

  // MPA Rating Colors.
  static Color backColorMPA = Colors.white70;
  static Color textColorMPA = Colors.black;

  // General Colors.
  static Color whiteIconColor = Colors.white;
  static Color whiteTitleColor0 = Colors.white24;
  static Color whiteTitleColor1 = Colors.white54;
  static Color whiteTitleColor2 = Colors.white60;
  static Color whiteTitleColor3 = Colors.white70;

  // TextField
  static OutlineInputBorder primaryBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.transparent, width: 0),
    borderRadius: BorderRadius.circular(10),
  );

  static OutlineInputBorder borderFocus = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.white60, width: 0.4),
    borderRadius: BorderRadius.circular(10),
  );

  static Color textFieldBackColor = Color(0xff181a1c);
}

// defined later manually *o*
class LightTheme {}
