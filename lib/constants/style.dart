import 'package:flutter/material.dart';

import 'index.dart';

class CStyle {
  CStyle._();
  static ButtonStyle button = ButtonStyle(
      minimumSize: const MaterialStatePropertyAll(Size(double.infinity, CHeight.medium)),
      padding: const MaterialStatePropertyAll(EdgeInsets.all(0.0)),
      backgroundColor: MaterialStatePropertyAll(CColor.primary),
      foregroundColor: const MaterialStatePropertyAll(Colors.white),
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(CSpace.medium)),
          side: BorderSide(color: CColor.primary))),
      textStyle: const MaterialStatePropertyAll(TextStyle(fontSize: CFontSize.headline4)));

  static ButtonStyle buttonWhite = button.copyWith(
    elevation: const MaterialStatePropertyAll(5),
    shadowColor: MaterialStatePropertyAll(CColor.black.shade50),
    backgroundColor: const MaterialStatePropertyAll(Colors.white),
    foregroundColor: MaterialStatePropertyAll(CColor.black),
    shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(CSpace.medium)), side: BorderSide(color: Colors.transparent))),
  );

  static ButtonStyle buttonOutline = ButtonStyle(
      side: MaterialStatePropertyAll(BorderSide(width: 1.0, color: CColor.primary)),
      padding: const MaterialStatePropertyAll(EdgeInsets.all(0.0)),
      shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(CSpace.medium)),
      )));

  static ButtonStyle buttonOutlinePrimary = buttonOutline.copyWith(
    backgroundColor: MaterialStatePropertyAll(CColor.primary),
  );

  static ButtonStyle buttonDanger = button.copyWith(
    elevation: const MaterialStatePropertyAll(5),
    shadowColor: MaterialStatePropertyAll(CColor.black.shade50),
    backgroundColor: MaterialStatePropertyAll(CColor.danger),
    foregroundColor: const MaterialStatePropertyAll(Colors.white),
    shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(CSpace.medium)), side: BorderSide(color: Colors.transparent))),
  );

  static ButtonStyle buttonIcon = button.copyWith(
      shape: const MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(CSpace.mediumSmall)))));

  static TextStyle title = TextStyle(fontSize: CFontSize.headline3, fontWeight: FontWeight.w600, color: CColor.black);
  static TextStyle padding1 = TextStyle(fontSize: CFontSize.paragraph1, color: CColor.black);
}
