import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/utils/index.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
