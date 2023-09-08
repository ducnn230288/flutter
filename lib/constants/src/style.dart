import 'package:flutter/material.dart';

import 'colors.dart';
import 'dimens.dart';

class CStyle {
  CStyle._();

  static const double radius = 5;

  static ButtonStyle button = ButtonStyle(
      minimumSize:
          const MaterialStatePropertyAll(Size(double.infinity, CHeight.medium)),
      elevation: const MaterialStatePropertyAll(0),
      padding: const MaterialStatePropertyAll(EdgeInsets.all(0.0)),
      backgroundColor: MaterialStatePropertyAll(CColor.primary),
      foregroundColor: const MaterialStatePropertyAll(Colors.white),
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(radius)),
          side: BorderSide(color: CColor.primary))),
      textStyle: const MaterialStatePropertyAll(
          TextStyle(fontSize: CFontSize.body, fontWeight: FontWeight.w400)));

  static ButtonStyle buttonSmall = button.copyWith(
      minimumSize:
          const MaterialStatePropertyAll(Size(double.infinity, CHeight.small)),
      shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)))),
      textStyle: const MaterialStatePropertyAll(
          TextStyle(fontSize: CFontSize.body, fontWeight: FontWeight.w400)));

  static ButtonStyle buttonFill({required Color backgroundColor}) =>
      ButtonStyle(
          minimumSize: const MaterialStatePropertyAll(
              Size(double.infinity, CHeight.medium)),
          elevation: const MaterialStatePropertyAll(0),
          padding: const MaterialStatePropertyAll(EdgeInsets.all(0.0)),
          backgroundColor: MaterialStatePropertyAll(backgroundColor),
          foregroundColor: const MaterialStatePropertyAll(Colors.white),
          shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius)))),
          textStyle: const MaterialStatePropertyAll(TextStyle(
              fontSize: CFontSize.body, fontWeight: FontWeight.w400)));

  static ButtonStyle buttonWhite = button.copyWith(
    shadowColor: MaterialStatePropertyAll(CColor.black.shade50),
    elevation: const MaterialStatePropertyAll(0),
    backgroundColor: const MaterialStatePropertyAll(Colors.white),
    foregroundColor: MaterialStatePropertyAll(CColor.black),
    shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        side: BorderSide(color: Colors.transparent))),
  );

  static ButtonStyle buttonOutline = button.copyWith(
    shadowColor: MaterialStatePropertyAll(CColor.black.shade50),
    elevation: const MaterialStatePropertyAll(0),
    backgroundColor: const MaterialStatePropertyAll(Colors.white),
    foregroundColor: MaterialStatePropertyAll(CColor.primary),
    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(radius)),
        side: BorderSide(color: CColor.primary))),
  );

  static ButtonStyle buttonOutlinePrimary = buttonOutline.copyWith(
    backgroundColor: MaterialStatePropertyAll(CColor.primary),
  );

  static ButtonStyle buttonHint = button.copyWith(
      backgroundColor: MaterialStatePropertyAll(CColor.black.shade50),
      elevation: const MaterialStatePropertyAll(0),
      shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      )));

  static ButtonStyle buttonDanger = button.copyWith(
    elevation: const MaterialStatePropertyAll(0),
    shadowColor: MaterialStatePropertyAll(CColor.black.shade50),
    backgroundColor: MaterialStatePropertyAll(CColor.danger),
    foregroundColor: const MaterialStatePropertyAll(Colors.white),
    shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        side: BorderSide(color: Colors.transparent))),
  );

  static ButtonStyle buttonStyle({ButtonStyle? buttonStyle}) => button
      .copyWith(
        shadowColor: buttonStyle?.shadowColor ??
            MaterialStatePropertyAll(CColor.black.shade50),
        backgroundColor: buttonStyle?.backgroundColor ??
            MaterialStatePropertyAll(CColor.danger),
        foregroundColor: buttonStyle?.foregroundColor ??
            const MaterialStatePropertyAll(Colors.white),
        shape: buttonStyle?.shape ??
            const MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(radius)),
                side: BorderSide(color: Colors.transparent))),
      )
      .merge(buttonStyle);

  static ButtonStyle buttonIcon = button.copyWith(
      shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)))));

  static TextStyle title = TextStyle(
      fontSize: CFontSize.body,
      fontWeight: FontWeight.w600,
      color: CColor.black);

  static TextStyle padding1 =
      TextStyle(fontSize: CFontSize.paragraph1, color: CColor.black);

  static TextStyle padding1Medium = TextStyle(
    fontSize: CFontSize.paragraph1,
    color: CColor.black,
    fontWeight: FontWeight.w600,
  );

  static TextStyle headline4 =
      TextStyle(fontSize: CFontSize.headline4, color: CColor.black);

  static TextStyle headline4Bold = TextStyle(
    fontSize: CFontSize.headline4,
    color: CColor.black,
    fontWeight: FontWeight.w600,
  );

  static TextStyle caption({TextStyle? style}) => TextStyle(
          height: CFontSize.lineHeight(style?.fontSize ?? CFontSize.subhead))
      .merge(style);

  static TextStyle base({TextStyle? style}) => TextStyle(
        fontSize: CFontSize.paragraph1,
        fontWeight: FontWeight.w400,
        color: CColor.black,
      ).merge(style);

  static BoxDecoration decoration({BoxDecoration? decoration}) => BoxDecoration(
        color: decoration?.color ?? Colors.white,
        borderRadius: decoration?.borderRadius ?? BorderRadius.circular(radius),
        shape: decoration?.shape ?? BoxShape.rectangle,
        border: decoration?.border,
        gradient: decoration?.gradient,
        boxShadow: decoration?.boxShadow ??
            [
              const BoxShadow(
                color: Color.fromRGBO(17, 12, 34, 0.12),
                offset: Offset(0, 2),
                blurRadius: 4,
              )
            ],
      );
}
