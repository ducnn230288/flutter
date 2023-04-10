import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

import '/constants/index.dart';
import '/cubit/index.dart';
import '/utils/index.dart';

void main() async {
  await dotenv.load(fileName: Environment.fileName);
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(supportedLocales: const [
    // Locale('en'),
    Locale('vi'),
  ], path: 'assets/translations', fallbackLocale: const Locale('vi'), child: MyApp()));
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
            BlocProvider<AuthC>(
              create: (BuildContext context) => AuthC(),
            ),
          ],
          child: MaterialApp.router(
            title: 'UberRental',
            builder: (BuildContext context, Widget? child) => GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: child!,
            ),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: ThemeData(
              textTheme: GoogleFonts.manropeTextTheme(),
              primarySwatch: CColor.primary,
              unselectedWidgetColor: CColor.primary,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: CStyle.button,
              ),
            ),
            routeInformationProvider: routes.routeInformationProvider,
            routeInformationParser: routes.routeInformationParser,
            routerDelegate: routes.routerDelegate,
          ),
        ));
  }
}
