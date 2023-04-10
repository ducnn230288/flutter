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
      500: Color(0xFF0C8720),
      600: Color(0xFF0A6B19),
      700: Color(0xFF074F13),
      800: Color(0xFF05330C),
      900: Color(0xFF021705),
    },
  ); // 15 - 6 - 0
  static MaterialColor black = const MaterialColor(
    0xFF2C2C2c,
    <int, Color>{
      50: Color(0xFFF3f3f3),
      100: Color(0xFFE0E0E0),
      200: Color(0xFFA8A8A8),
      300: Color(0xFF8F8F8F),
      400: Color(0xFF696969),
      500: Color(0xFF333333),
      600: Color(0xFF2C2C2c),
      700: Color(0xFF1A1A1A),
      800: Color(0xFF0D0D0D),
      900: Color(0xFF000000),
    },
  ); // 17 - 5 - 0

  static MaterialColor warning = const MaterialColor(
    0xFFE08A09,
    <int, Color>{
      50: Color(0xFFFFFEFD),
      100: Color(0xFFFEF2E0),
      200: Color(0xFFFBD9A5),
      300: Color(0xFFF9C06A),
      400: Color(0xFFF7A730),
      500: Color(0xFFE08A09),
      600: Color(0xFFB46F07),
      700: Color(0xFF885405),
      800: Color(0xFF5C3804),
      900: Color(0xFF2F1D02),
    },
  ); // 12 - 9 - 0

  static MaterialColor danger = const MaterialColor(
    0xFFE04A09,
    <int, Color>{
      50: Color(0xFFFFFEFD),
      100: Color(0xFFFEE9E0),
      200: Color(0xFFFBBFA5),
      300: Color(0xFFF9966A),
      400: Color(0xFFF76C30),
      500: Color(0xFFE04A09),
      600: Color(0xFFB43B07),
      700: Color(0xFF882D05),
      800: Color(0xFF5C1E04),
      900: Color(0xFF2F1002),
    },
  ); // 12 - 9 - 0

  static Color statusColor(String status) {
    switch (status) {
      case 'DRAFT':
      case 'CANCELED':
      case 'TRANSFER_UNCONFIRMED':
        return black.shade200;

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
        return Colors.lightBlue;

      case 'UN_USED':
      case 'WAIT_CONFIRM':
      case 'WFA':
      case 'WAIT_TRANSFER':
      case 'CUSTOMER':
        return Colors.green;

      case 'APPROVE':
      case 'APPROVED':
      case 'COMPLETED':
      case 'TRANSFER_CONFIRMED':
      case 'VERIFIED':
        return Colors.blue;

      case 'LOCKED':
      case 'LOCK_PROPOSAL':
        return Colors.teal;
    }
    return primary;
  }
}
