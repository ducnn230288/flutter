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
  static Color primaryColor = Color(primary);
  static Color blackColor = const Color(0xff2c2c2c);
  static Color accentColor = const Color(0xffE04A09);
  static Color hintColor = const Color(0xff696969);
  static Color grayColor = const Color(0xffA8A8A8);
  static Color lightColor = const Color(0xffF3F3F3);

  static double gap = 17.0;

  static TextStyle titleStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.w800, color: blackColor);
  static ButtonStyle button = ButtonStyle(
      minimumSize: const MaterialStatePropertyAll(Size(double.infinity, 48)),
      padding: const MaterialStatePropertyAll(EdgeInsets.all(0.0)),
      backgroundColor: MaterialStatePropertyAll(primaryColor),
      foregroundColor: const MaterialStatePropertyAll(Colors.white),
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)), side: BorderSide(color: primaryColor))),
      textStyle: const MaterialStatePropertyAll(TextStyle(fontSize: 16)));
  static ButtonStyle buttonWhite = button.copyWith(
    elevation: const MaterialStatePropertyAll(5),
    shadowColor: MaterialStatePropertyAll(lightColor),
    backgroundColor: const MaterialStatePropertyAll(Colors.white),
    foregroundColor: MaterialStatePropertyAll(blackColor),
    shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)), side: BorderSide(color: Colors.transparent))),
  );
}
