import 'package:flutter/material.dart';

import 'colors.dart';
import 'dimens.dart';

class CStyle {
  CStyle._();

  static const double radius = 5;

  static ButtonStyle button = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll((Size(double.infinity, CHeight.xl2))),
      elevation: const WidgetStatePropertyAll(0),
      padding: const WidgetStatePropertyAll(EdgeInsets.all(0.0)),
      backgroundColor: WidgetStatePropertyAll(CColor.primary),
      foregroundColor: const WidgetStatePropertyAll(Colors.white),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(radius)), side: BorderSide(color: CColor.primary))),
      textStyle: const WidgetStatePropertyAll(TextStyle(fontSize: CFontSize.base, fontWeight: FontWeight.w400)));

  static ButtonStyle buttonSmall = button.copyWith(
      minimumSize: const WidgetStatePropertyAll(Size(double.infinity, CHeight.base)),
      shape:
          const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(radius)))),
      textStyle: const WidgetStatePropertyAll(TextStyle(fontSize: CFontSize.base, fontWeight: FontWeight.w400)));

  static ButtonStyle buttonFill({required Color backgroundColor}) => ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(double.infinity, CHeight.xl2)),
      elevation: const WidgetStatePropertyAll(0),
      padding: const WidgetStatePropertyAll(EdgeInsets.all(0.0)),
      backgroundColor: WidgetStatePropertyAll(backgroundColor),
      foregroundColor: const WidgetStatePropertyAll(Colors.white),
      shape:
          const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(radius)))),
      textStyle: const WidgetStatePropertyAll(TextStyle(fontSize: CFontSize.base, fontWeight: FontWeight.w400)));

  static ButtonStyle buttonWhite = button.copyWith(
    shadowColor: WidgetStatePropertyAll(CColor.black.shade100.withOpacity(0.2)),
    elevation: const WidgetStatePropertyAll(0),
    backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
    foregroundColor: WidgetStatePropertyAll(CColor.black),
    shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)), side: BorderSide(color: Colors.transparent))),
  );

  static ButtonStyle buttonOutline = button.copyWith(
    shadowColor: WidgetStatePropertyAll(CColor.black.shade100.withOpacity(0.2)),
    elevation: const WidgetStatePropertyAll(0),
    backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
    foregroundColor: WidgetStatePropertyAll(CColor.primary),
    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(radius)), side: BorderSide(color: CColor.primary))),
  );

  static ButtonStyle buttonOutlinePrimary = buttonOutline.copyWith(
    backgroundColor: WidgetStatePropertyAll(CColor.primary),
  );

  static ButtonStyle buttonHint = button.copyWith(
      backgroundColor: WidgetStatePropertyAll(CColor.black.shade100.withOpacity(0.2)),
      elevation: const WidgetStatePropertyAll(0),
      shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      )));

  static ButtonStyle buttonDanger = button.copyWith(
    elevation: const WidgetStatePropertyAll(0),
    shadowColor: WidgetStatePropertyAll(CColor.black.shade100.withOpacity(0.2)),
    backgroundColor: WidgetStatePropertyAll(CColor.danger),
    foregroundColor: const WidgetStatePropertyAll(Colors.white),
    shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)), side: BorderSide(color: Colors.transparent))),
  );

  static ButtonStyle buttonStyle({ButtonStyle? buttonStyle}) => button
      .copyWith(
        shadowColor: buttonStyle?.shadowColor ?? WidgetStatePropertyAll(CColor.black.shade100.withOpacity(0.2)),
        backgroundColor: buttonStyle?.backgroundColor ?? WidgetStatePropertyAll(CColor.danger),
        foregroundColor: buttonStyle?.foregroundColor ?? const WidgetStatePropertyAll(Colors.white),
        shape: buttonStyle?.shape ??
            const WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(radius)), side: BorderSide(color: Colors.transparent))),
      )
      .merge(buttonStyle);

  static ButtonStyle buttonIcon = button.copyWith(
      shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(radius)))));

  static TextStyle title = TextStyle(fontSize: CFontSize.base, fontWeight: FontWeight.w600, color: CColor.black);

  static TextStyle padding1 = TextStyle(fontSize: CFontSize.sm, color: CColor.black);

  static TextStyle padding1Medium = TextStyle(
    fontSize: CFontSize.sm,
    color: CColor.black,
    fontWeight: FontWeight.w600,
  );

  static TextStyle headline4 = TextStyle(fontSize: CFontSize.base, color: CColor.black);

  static TextStyle headline4Bold = TextStyle(
    fontSize: CFontSize.base,
    color: CColor.black,
    fontWeight: FontWeight.w600,
  );

  static TextStyle base({TextStyle? style}) => TextStyle(
        fontSize: CFontSize.sm,
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
