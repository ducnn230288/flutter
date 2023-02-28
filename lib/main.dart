import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '/constants/index.dart';
import '/cubit/index.dart';
import '/utils/index.dart';
import 'routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final Api _api = Api();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: _api,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AppAuthCubit>(
              create: (BuildContext context) => AppAuthCubit(),
            ),
          ],
          child: MaterialApp.router(
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
            routeInformationProvider: routes.routeInformationProvider,
            routeInformationParser: routes.routeInformationParser,
            routerDelegate: routes.routerDelegate,
          ),
        ));
  }
}
