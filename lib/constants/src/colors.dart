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
  static MaterialColor violet = const MaterialColor(
    0xFF8b5cf6,
    <int, Color>{
      50: Color(0xFFf5f3ff),
      100: Color(0xFFede9fe),
      200: Color(0xFFddd6fe),
      300: Color(0xFFc4b5fd),
      400: Color(0xFFa78bfa),
      500: Color(0xFF8b5cf6),
      600: Color(0xFF7c3aed),
      700: Color(0xFF6d28d9),
      800: Color(0xFF5b21b6),
      900: Color(0xFF4c1d95),
      950: Color(0xFF2e1065),
    },
  );

  static Color statusColor(String status) {
    switch (status) {
      case 'LOCKED':
      case 'REJECTED':
      case 'CANCELED':
        return danger;

      case 'WFA':
      case 'WAIT_TRANSFER':
      case 'WAIT_CONFIRM':
        return warning;

      case 'ACTIVE':
      case 'APPROVED':
      case 'COMPLETED':
        return green;

      case 'TRANSFER_CONFIRMED':
        return blue;

      case 'CLOSED':
      case 'UN_CONFIRM':
        return black;

      case 'DRAFT':
        return black.shade500;

      case 'VERIFIED':
        return violet;
    }
    return primary;
  }
}
