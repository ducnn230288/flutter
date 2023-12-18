import 'package:flutter/material.dart';

class CFontSize {
  CFontSize._();

  static const double paragraph1 = 14.0;
  static const double paragraph2 = 12.0;
  static const double paragraph3 = 10.0;
  static const double paragraph4 = 8.0;
  static const double headline1 = 32.0;
  static const double headline2 = 24.0;
  static const double headline3 = 18.0;
  static const double headline4 = 16.0;

  static const double largeTitle = 34.0;
  static const double title1 = 28.0;
  static const double title2 = 22.0;
  static const double title3 = 20.0;
  static const double headline = 17.0;
  static const double body = 17.0;
  static const double callOut = 16.0;
  static const double subhead = 15.0;
  static const double footnote = 13.0;
  static const double caption1 = 12.0;
  static const double caption2 = 11.0;

  static Map<String, List<double>> typeSizesIOS = {
    'largeTitle': [34, 41],
    'title1': [28, 34],
    'title2': [22, 28],
    'title3': [20, 25],
    'headline': [17, 22],
    'body': [17, 22],
    'callOut': [16, 21],
    'subhead': [15, 20],
    'footnote': [13, 18],
    'caption1': [12, 16],
    'caption2': [11, 13],
  };

  static double? lineHeight(double fontSize) {
    double? height;
    typeSizesIOS.forEach((key, value) {
      if (fontSize == 11 || fontSize == 12) {
        height = value[1] / value[0];
      } else if (fontSize == value[0]) {
        height = (value[0] + value[1]) / value[0];
      } else {
        height = null;
      }
    });
    return height;
  }
}

class CSpace {
  CSpace._();

  static const superLarge = 24.0;
  static const xlarge = 20.0;

  static const large = 16.0;

  static const medium = 12.0;
  static const mediumSmall = 8.0;

  static const small = 6.0;
  static const superSmall = 4.0;

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

  static const double large = 60.0;

  static const double medium = 48.0;
  static const double mediumSmall = 40.0;

  static const double small = 36.0;
  static const double superSmall = 30.0;
}

class CRadius {
  CRadius._();

  static const superLarge = 24.0;
  static const large = 16.0;
  static const medium = 12.0;
  static const mediumSmall = 8.0;
  static const small = 6.0;
  static const basic = 5.0;
  static const superSmall = 4.0;
}
