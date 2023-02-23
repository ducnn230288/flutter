import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uberentaltest/constants.dart';

class AppIcons {
  AppIcons._();

  static final logo = SvgPicture.asset('assets/svgs/logo.svg', semanticsLabel: 'Logo');
  static final arrowLeft = SvgPicture.asset(
    'assets/svgs/arrow-left.svg',
    semanticsLabel: 'arrow left',
    width: FontSizes.headline3,
    color: Colors.white,
  );
  static final arrowRight = SvgPicture.asset(
    'assets/svgs/arrow-right.svg',
    semanticsLabel: 'arrow left',
    width: FontSizes.paragraph2,
    color: ColorName.primary,
  );
  static final menuRight = SvgPicture.asset(
    'assets/svgs/menu-right.svg',
    semanticsLabel: 'Menu',
    width: FontSizes.headline2,
    color: ColorName.black,
  );
  static final close = SvgPicture.asset(
    'assets/svgs/close.svg',
    semanticsLabel: 'Close',
    width: FontSizes.paragraph2,
    color: Colors.white,
  );
}
