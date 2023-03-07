import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/constants/index.dart';

class AppIcons {
  AppIcons._();

  static final logo = SvgPicture.asset('assets/svgs/logo.svg', semanticsLabel: 'Logo');
  static final logoWhite = Image.asset(
    'assets/images/splash.png',
    width: 175,
  );
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
  static final search = SvgPicture.asset(
    'assets/svgs/search.svg',
    semanticsLabel: 'Search',
    width: FontSizes.headline3,
    color: Colors.white,
  );
  static final arrowDown = SvgPicture.asset(
    'assets/svgs/arrow-down.svg',
    semanticsLabel: 'Arrow down',
    color: ColorName.black.shade200,
    width: 0,
  );
  static final placeholderImage = Image.asset(
    'assets/images/placeholder.jpeg',
  );
}
