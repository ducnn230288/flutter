import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        primarySwatch: AppThemes.myColor,
        unselectedWidgetColor: AppThemes.primaryColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: AppThemes.button,
        ),
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: RoutesName.introductionPage,
    );
  }
}
