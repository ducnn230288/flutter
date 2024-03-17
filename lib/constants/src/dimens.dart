import 'package:flutter/material.dart';

class CFontSize {
  CFontSize._();

  static const double xs = 12.0;
  static const double sm = 14.0;
  static const double base = 16.0;
  static const double lg = 18.0;
  static const double xl = 20.0;
  static const double xl2 = 24.0;
  static const double xl3 = 30.0;
  static const double xl4 = 36.0;
}

class CSpace {
  CSpace._();

  static const xs = 4.0;
  static const sm = 6.0;
  static const base = 8.0;
  static const lg = 10.0;
  static const xl = 12.0;
  static const xl2 = 14.0;
  static const xl3 = 16.0;
  static const xl4 = 20.0;
  static const xl5 = 24.0;

  static double _width = 0;
  static double _height = 0;
  static double get width => _width;
  static double get height => _height;
  static void setScreenSize(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
  }
}

class CHeight {
  CHeight._();

  static const xs = 28.0;
  static const sm = 32.0;
  static const base = 36.0;
  static const lg = 40.0;
  static const xl = 44.0;
  static const xl2 = 48.0;
  static const xl3 = 56.0;
  static const xl4 = 64.0;
}
