import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_app/main.dart';
import 'package:flutter_app/utils/index.dart';
import 'package:flutter_app/widgets/src/button/index.dart';

Future<void> initAppWidgetTest(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  await dotenv.load(fileName: Environment.fileName);
  await EasyLocalization.ensureInitialized();
  await tester.pumpWidget(EasyLocalization(supportedLocales: const [
    // Locale('en'),
    Locale('vi'),
  ], path: 'assets/translations', fallbackLocale: const Locale('vi'), child: MyApp()));
  await tester.pumpAndSettle();
}

Future<void> tapButtonPump(
    WidgetTester tester,
    String text, {
      Type type = WButton
    }) async {
  await tester.tap(find.widgetWithText(type, text));
  await tester.pumpAndSettle();
}


Future<void> pumpUntilFound(
    WidgetTester tester,
    Finder finder, {
      Duration timeout = const Duration(seconds: 60),
    }) async {
  bool timerDone = false;
  final timer = Timer(timeout, () => timerDone = true);
  while (timerDone != true) {
    await tester.pumpAndSettle();

    final found = tester.any(finder);
    if (found) {
      timerDone = true;
    }
  }
  timer.cancel();
}
