import 'package:flutter/material.dart';

import 'index.dart';

class Style {
  Style._();
  static ButtonStyle button = ButtonStyle(
      minimumSize: const MaterialStatePropertyAll(Size(double.infinity, Height.medium)),
      padding: const MaterialStatePropertyAll(EdgeInsets.all(0.0)),
      backgroundColor: MaterialStatePropertyAll(ColorName.primary),
      foregroundColor: const MaterialStatePropertyAll(Colors.white),
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(Space.medium)),
          side: BorderSide(color: ColorName.primary))),
      textStyle: const MaterialStatePropertyAll(TextStyle(fontSize: FontSizes.headline4)));

  static ButtonStyle buttonWhite = button.copyWith(
    elevation: const MaterialStatePropertyAll(5),
    shadowColor: MaterialStatePropertyAll(ColorName.black.shade50),
    backgroundColor: const MaterialStatePropertyAll(Colors.white),
    foregroundColor: MaterialStatePropertyAll(ColorName.black),
    shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(Space.medium)), side: BorderSide(color: Colors.transparent))),
  );

  static ButtonStyle buttonIcon = button.copyWith(
      shape: const MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Space.mediumSmall)))));

  static TextStyle title =
      TextStyle(fontSize: FontSizes.headline3, fontWeight: FontWeight.w600, color: ColorName.black);
}
