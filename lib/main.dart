import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '/bloc/index.dart';
import 'constants/index.dart';
import 'pages/index.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocWidget(
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
        routeInformationProvider: _router.routeInformationProvider,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
      ),
    );
  }

  final GlobalKey<NavigatorState> _navigatorState = GlobalKey<NavigatorState>();

  late final GoRouter _router = GoRouter(
    initialLocation: RoutesName.introduction,
    navigatorKey: _navigatorState,
    routes: [
      GoRoute(
        name: RoutesName.introduction,
        path: RoutesName.introduction,
        builder: (BuildContext context, GoRouterState state) {
          return const IntroductionPage();
        },
      ),
      ShellRoute(
        // builder: (BuildContext context, GoRouterState state, Widget child) {
        //   return LoginLayout(
        //     extra: state.extra,
        //     child: child,
        //   );
        // },
        routes: <RouteBase>[
          GoRoute(
            name: RoutesName.login,
            path: RoutesName.login,
            builder: (BuildContext context, GoRouterState state) {
              return const LoginPage();
            },
          ),
          GoRoute(
            name: RoutesName.register,
            path: RoutesName.register,
            builder: (BuildContext context, GoRouterState state) {
              return const RegisterPage();
            },
          ),
          GoRoute(
            name: RoutesName.otpVerification,
            path: RoutesName.otpVerification,
            builder: (BuildContext context, GoRouterState state) {
              return OTPVerificationPage(extra: state.extra);
            },
          ),
        ],
      ),
      GoRoute(
        name: RoutesName.home,
        path: RoutesName.home,
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),
    ],
  );
}
