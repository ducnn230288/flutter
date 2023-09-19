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
  static final forgotPassword = SvgPicture.asset(
    'assets/svgs/forgot-password.svg',
    semanticsLabel: 'forgot-password',
    colorFilter: ColorFilter.mode(CColor.primary, BlendMode.srcIn),
  );
  static final otpVerification = SvgPicture.asset(
    'assets/svgs/otp-verification.svg',
    semanticsLabel: 'otp-verification',
    colorFilter: ColorFilter.mode(CColor.primary, BlendMode.srcIn),
  );
  static final resetPassword = SvgPicture.asset(
    'assets/svgs/reset-password.svg',
    semanticsLabel: 'reset-password',
    colorFilter: ColorFilter.mode(CColor.primary, BlendMode.srcIn),
  );
  static final arrowDown = SvgPicture.asset(
    'assets/svgs/arrow-down.svg',
    semanticsLabel: 'Arrow down',
    colorFilter: ColorFilter.mode(CColor.black.shade200, BlendMode.srcIn),
    width: 0,
  );
  static final arrowRight = SvgPicture.asset(
    'assets/svgs/arrow-right.svg',
    semanticsLabel: 'arrow left',
    width: CFontSize.headline4,
    colorFilter: ColorFilter.mode(CColor.primary, BlendMode.srcIn),
  );
  static final close = SvgPicture.asset(
    'assets/svgs/close.svg',
    semanticsLabel: 'Close',
    width: 0,
    colorFilter: ColorFilter.mode(CColor.black.shade300, BlendMode.srcIn),
  );
  static final closeWhite = SvgPicture.asset(
    'assets/svgs/close.svg',
    semanticsLabel: 'Close',
    width: CFontSize.paragraph2,
    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
  );
  static final copy = SvgPicture.asset(
    'assets/svgs/copy.svg',
    semanticsLabel: 'Copy',
    width: CFontSize.paragraph2,
    colorFilter: ColorFilter.mode(CColor.primary, BlendMode.srcIn),
  );
  static final search = SvgPicture.asset(
    'assets/svgs/search.svg',
    semanticsLabel: 'Search',
    width: CFontSize.headline4,
    colorFilter: ColorFilter.mode(CColor.black.shade400, BlendMode.srcIn),
  );
}
