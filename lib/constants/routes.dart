import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/cubit/index.dart';
import '/pages/index.dart';

class CRoute {
  static const String home = '/home';

  static const String splash = '/splash';
  static const String introduction = '/introduction';
  static const String login = 'login';
  static const String register = 'register';
  static const String otpVerification = '/otp-verification';
  static const String user = 'user';
}

final rootNavigatorKey = GlobalKey<NavigatorState>();
final GoRouter routes = GoRouter(
  initialLocation: CRoute.splash,
  navigatorKey: rootNavigatorKey,
  routes: [
    splashRoute(),
    introductionRoute(),
    otpVerificationRoute(),
    homeRoute(),
  ],
);
GoRoute splashRoute() => GoRoute(
      name: CRoute.splash,
      path: CRoute.splash,
      builder: (BuildContext context, GoRouterState state) => const SplashPage(),
    );

GoRoute introductionRoute() => GoRoute(
        name: CRoute.introduction,
        path: CRoute.introduction,
        builder: (BuildContext context, GoRouterState state) => const IntroductionPage(),
        routes: [
          GoRoute(
              name: CRoute.login,
              path: CRoute.login,
              builder: (BuildContext context, GoRouterState state) => blocForm(
                    child: const LoginPage(),
                  )),
          GoRoute(
              name: CRoute.register,
              path: CRoute.register,
              builder: (BuildContext context, GoRouterState state) => blocForm(
                    child: const RegisterPage(),
                  ))
        ]);
GoRoute otpVerificationRoute() => GoRoute(
    name: CRoute.otpVerification,
    path: CRoute.otpVerification,
    builder: (BuildContext context, GoRouterState state) => blocForm(child: OTPVerificationPage(extra: state.extra)));

blocForm({required Widget child}) => BlocListener<AuthC, AuthS>(
    listenWhen: (oldState, newState) => newState.status == AppStatus.fails,
    listener: (context, state) => GoRouter.of(context).goNamed(CRoute.introduction),
    child: BlocProvider(
      create: (context) => BlocC(),
      child: child,
    ));
GoRoute homeRoute() => GoRoute(
        name: CRoute.home,
        path: CRoute.home,
        builder: (BuildContext context, GoRouterState state) => blocForm(child: const HomePage()),
        routes: [
          GoRoute(
            name: CRoute.user,
            path: CRoute.user,
            builder: (BuildContext context, GoRouterState state) => blocForm(child: const UserPage()),
          )
        ]);
