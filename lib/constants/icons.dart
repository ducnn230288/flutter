import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/constants/index.dart';

class CIcon {
  CIcon._();

  static final logo = Image.asset('assets/images/logo.png');

  // SvgPicture.asset('assets/svgs/logo.svg', semanticsLabel: 'Logo',);
  static final logoWhite = Image.asset(
    'assets/images/splash.png',
    width: 175,
  );
  static final arrowLeft = SvgPicture.asset(
    'assets/svgs/arrow-left.svg',
    semanticsLabel: 'arrow left',
    width: CFontSize.headline3,
    color: Colors.white,
  );
  static final arrowRight = SvgPicture.asset(
    'assets/svgs/arrow-right.svg',
    semanticsLabel: 'arrow left',
    width: CFontSize.paragraph2,
    color: CColor.primary,
  );
  static final menuRight = SvgPicture.asset(
    'assets/svgs/menu-right.svg',
    semanticsLabel: 'Menu',
    width: CFontSize.headline2,
    color: CColor.black,
  );
  static final arrowRightWhite = SvgPicture.asset(
    'assets/svgs/arrow-right.svg',
    semanticsLabel: 'arrow left',
    width: CFontSize.paragraph2,
    color: Colors.white,
  );
  static final close = SvgPicture.asset(
    'assets/svgs/close.svg',
    semanticsLabel: 'Close',
    width: CFontSize.paragraph2,
    color: Colors.white,
  );
  static final search = SvgPicture.asset(
    'assets/svgs/search.svg',
    semanticsLabel: 'Search',
    width: CFontSize.headline3,
    color: Colors.white,
  );
  static final arrowDown = SvgPicture.asset(
    'assets/svgs/arrow-down.svg',
    semanticsLabel: 'Arrow down',
    color: CColor.black.shade200,
    width: 0,
  );
  static final placeholderImage = Image.asset(
    'assets/images/placeholder.jpeg',
  );
  static final remove = SvgPicture.asset(
    'assets/svgs/remove.svg',
    semanticsLabel: 'Remove',
    color: CColor.black.shade500,
    width: CHeight.mediumSmall / 2,
  );
  static final removeWhite = SvgPicture.asset(
    'assets/svgs/remove.svg',
    semanticsLabel: 'Remove',
    color: Colors.white,
    width: CHeight.mediumSmall / 2,
  );
  static final upload = SvgPicture.asset(
    'assets/svgs/upload.svg',
    semanticsLabel: 'Upload',
    color: CColor.black.shade500,
    width: CHeight.mediumSmall / 2,
  );
  static final add = SvgPicture.asset(
    'assets/svgs/add.svg',
    semanticsLabel: 'Add',
    width: CHeight.mediumSmall / 2,
    color: Colors.white,
  );
  static final check = SvgPicture.asset(
    'assets/form/check.svg',
    semanticsLabel: 'Check',
    width: CFontSize.paragraph2,
    color: CColor.primary,
  );
}
