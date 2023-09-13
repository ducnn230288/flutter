import 'package:flutter/material.dart';

class CColor {
  CColor._();

  static MaterialColor primary = const MaterialColor(
    0xFF0C8720,
    <int, Color>{
      50: Color(0xFFEDFFF0),
      100: Color(0xFFC9FFD1),
      200: Color(0xFF63BA70),
      300: Color(0xFF3EEE5B),
      400: Color(0xFF12CD31),
      500: Color(0xFF05991D),
      600: Color(0xFF16a34a),
      700: Color(0xFF15803d),
      800: Color(0xFF166534),
      900: Color(0xFF14532d),
      950: Color(0xFF052e16),
    },
  ); // 15 - 6 - 0
  static MaterialColor green = const MaterialColor(
    0xFF0C8720,
    <int, Color>{
      50: Color(0xFFEDFFF0),
      100: Color(0xFFC9FFD1),
      200: Color(0xFF63BA70),
      300: Color(0xFF3EEE5B),
      400: Color(0xFF12CD31),
      500: Color(0xFF05991D),
      600: Color(0xFF16a34a),
      700: Color(0xFF15803d),
      800: Color(0xFF166534),
      900: Color(0xFF14532d),
      950: Color(0xFF052e16),
    },
  );
  static MaterialColor black = const MaterialColor(
    0xFF2C2C2c,
    <int, Color>{
      50: Color(0xFFF3f3f3),
      100: Color(0xFFC2C2C2),
      200: Color(0xFFA8A8A8),
      300: Color(0xFF8F8F8F),
      400: Color(0xFF808080),
      500: Color(0xFF737373),
      600: Color(0xFF525252),
      700: Color(0xFF404040),
      800: Color(0xFF262626),
      900: Color(0xFF171717),
      950: Color(0xFF0a0a0a),
    },
  );
  static MaterialColor warning = const MaterialColor(
    0xFFeab308,
    <int, Color>{
      50: Color(0xFFfefce8),
      100: Color(0xFFfef9c3),
      200: Color(0xFFfef08a),
      300: Color(0xFFfde047),
      400: Color(0xFFfacc15),
      500: Color(0xFFeab308),
      600: Color(0xFFca8a04),
      700: Color(0xFFa16207),
      800: Color(0xFF854d0e),
      900: Color(0xFF713f12),
      950: Color(0xFF422006),
    },
  );
  static MaterialColor danger = const MaterialColor(
    0xFFef4444,
    <int, Color>{
      50: Color(0xFFfff7ed),
      100: Color(0xFFfee2e2),
      200: Color(0xFFfecaca),
      300: Color(0xFFfca5a5),
      400: Color(0xFFf87171),
      500: Color(0xFFef4444),
      600: Color(0xFFdc2626),
      700: Color(0xFFb91c1c),
      800: Color(0xFF991b1b),
      900: Color(0xFF7f1d1d),
      950: Color(0xFF450a0a),
    },
  );
  static MaterialColor blue = const MaterialColor(
    0xFF3b82f6,
    <int, Color>{
      50: Color(0xFFeff6ff),
      100: Color(0xFFdbeafe),
      200: Color(0xFFbfdbfe),
      300: Color(0xFF93c5fd),
      400: Color(0xFF60a5fa),
      500: Color(0xFF3b82f6),
      600: Color(0xFF2563eb),
      700: Color(0xFF1d4ed8),
      800: Color(0xFF1e40af),
      900: Color(0xFF1e3a8a),
      950: Color(0xFF172554),
    },
  );
  static MaterialColor purple = const MaterialColor(
    0xFFa855f7,
    <int, Color>{
      50: Color(0xFFfaf5ff),
      100: Color(0xFFf3e8ff),
      200: Color(0xFFe9d5ff),
      300: Color(0xFFd8b4fe),
      400: Color(0xFFc084fc),
      500: Color(0xFFa855f7),
      600: Color(0xFF9333ea),
      700: Color(0xFF7e22ce),
      800: Color(0xFF6b21a8),
      900: Color(0xFF581c87),
      950: Color(0xFF3b0764),
    },
  );

  static Color statusColor(String status) {
    switch (status) {
      case 'DRAFT':
      case 'CANCELED':
      case 'UN_CONFIRM':
        return black.shade300;

      case 'ADMIN_REJECTED':
      case 'REJECT':
      case 'ADMIN_REJECT':
      case 'REJECTED':
      case 'USED':
      case 'CLOSED':
      case 'SOLD':
      case 'END':
      case 'CLOSE_PROPOSAL':
      case 'NO_KYC_VERIFY':
      case 'EXPIRED':
        return danger;

      case 'PUBLISHED':
      case 'ACTIVE':
      case 'RECEIVE':
      case 'RECEIVED':
      case 'POST':
      case 'APPROVE':
      case 'APPROVED':
      case 'CONFIRMED':
      case 'VERIFIED':
      case 'COMPLETED':
      case 'USER_TRANSFER_CONFIRMED':
        return blue;

      case 'UN_USED':
      case 'WAIT_CONFIRM':
      case 'WFA':
      case 'WAIT_TRANSFER':
      case 'CUSTOMER':
      case 'WAIT_FOR_APPROVAL':
        return warning;

      case 'ASSIGNED':
        return purple;

      case 'LOCKED':
      case 'LOCK_PROPOSAL':
        return green.shade700;
    }
    return primary;
  }
}
