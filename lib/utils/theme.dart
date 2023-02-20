import 'package:flutter/material.dart';

class AppThemes {
  static int primary = 0xFF0C8720;
  static MaterialColor myColor = MaterialColor(
    primary,
    <int, Color>{
      50: Color(primary),
      100: Color(primary),
      200: Color(primary),
      300: Color(primary),
      400: Color(primary),
      500: Color(primary),
      600: Color(primary),
      700: Color(primary),
      800: Color(primary),
      900: Color(primary),
    },
  );
  static ButtonStyle buttonStyle = ButtonStyle(
      padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 10, vertical: 15)),
      backgroundColor: MaterialStatePropertyAll(Color(primary)),
      foregroundColor: const MaterialStatePropertyAll(Colors.white),
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)), side: BorderSide(color: Color(primary)))),
      textStyle: const MaterialStatePropertyAll(TextStyle(fontSize: 18)));
}
