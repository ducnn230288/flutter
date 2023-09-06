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
      600: Color(0xFF0A6B19),
      700: Color(0xFF074F13),
      800: Color(0xFF05330C),
      900: Color(0xFF021705),
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
      100: Color(0xFFC2C2C2),
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

  static MaterialColor red = const MaterialColor(
    0xFFE70A0A,
    <int, Color>{
      50: Color(0xFFFFEBEE),
      100: Color(0xFFFFCDD2),
      200: Color(0xFFEF9A9A),
      300: Color(0xFFE57373),
      400: Color(0xFFEF5350),
      500: Color(0xFFE70A0A), // primary color
      600: Color(0xFFE53935),
      700: Color(0xFFD32F2F),
      800: Color(0xFFC62828),
      900: Color(0xFFB71C1C),
    },
  );

  static Color statusColor(String status) {
    const Color hintColor = Color(0xFFABABAB);
    const Color pendingColor = Color(0xFFE08A09);
    const Color approvedColor = Color(0xFF0E9CD9);
    const Color workingColor = Color(0xFF08CBD8);
    const Color confirmColor = Color(0xFFF4C712);
    const Color refundColor = Color(0xFFF569AD);
    const Color completeColor = Color(0xFF0C8720);
    const Color accentColor = Color(0xFFE04A09);

    switch (status) {
      case 'DRAFT':
      case 'CANCELED':
      case 'UN_CONFIRM':
        return hintColor;

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
        return accentColor;

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
        return approvedColor;

      case 'UN_USED':
      case 'WAIT_CONFIRM':
      case 'WFA':
      case 'WAIT_TRANSFER':
      case 'CUSTOMER':
      case 'WAIT_FOR_APPROVAL':
        return pendingColor;

      case 'ASSIGNED':
        return refundColor;

      case 'LOCKED':
      case 'LOCK_PROPOSAL':
        return Colors.teal;
    }
    return primary;
  }

  static const Color hintButton = Color(0xFFF3F3F3);

  static Color hintColor = CColor.black.shade300;
}
