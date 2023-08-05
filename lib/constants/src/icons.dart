import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/constants/index.dart';

class CIcon {
  CIcon._();

  static final logo = Image.asset(
    'assets/images/logo.png',
    semanticLabel: 'logo',
  );
  static final logoLogin = Image.asset(
    'assets/images/logo_login.png',
    height: CSpace.height - 560,
    width: CSpace.width * 0.75,
    semanticLabel: 'logoLogin',
  );
  static final placeholderImage = Image.asset(
    'assets/images/placeholder.jpeg',
  );
  static final reminder = Image.asset(
    'assets/images/reminder.png',
    width: CSpace.width < 190 ? 190 : CSpace.width * 0.6,
    semanticLabel: 'reminder',
  );
  static final arrowDown = SvgPicture.asset(
    'assets/svgs/arrow-down.svg',
    semanticsLabel: 'Arrow down',
    color: CColor.black.shade200,
    width: 0,
  );
  static final arrowRight = SvgPicture.asset(
    'assets/svgs/arrow-right.svg',
    semanticsLabel: 'arrow left',
    width: CFontSize.headline4,
    color: CColor.primary,
  );
  static final close = SvgPicture.asset(
    'assets/svgs/close.svg',
    semanticsLabel: 'Close',
    width: 0,
    color: CColor.black.shade300,
  );
  static final closeWhite = SvgPicture.asset(
    'assets/svgs/close.svg',
    semanticsLabel: 'Close',
    width: CFontSize.paragraph2,
    color: Colors.white,
  );
  static final copy = SvgPicture.asset(
    'assets/svgs/copy.svg',
    semanticsLabel: 'Copy',
    width: CFontSize.paragraph2,
    color: CColor.primary,
  );
  static final search = SvgPicture.asset(
    'assets/svgs/search.svg',
    semanticsLabel: 'Search',
    width: CFontSize.headline4,
    color: CColor.black.shade400,
  );
}
