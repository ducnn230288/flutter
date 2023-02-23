import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/constants.dart';
import '/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Template',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.manropeTextTheme(),
        primarySwatch: ColorName.primary,
        unselectedWidgetColor: ColorName.primary,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: Style.button,
        ),
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: RoutesName.introductionPage,
    );
  }
}
