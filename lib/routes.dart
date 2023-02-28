import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/constants/index.dart';
import '/cubit/index.dart';
import '/pages/index.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final GoRouter routes = GoRouter(
  initialLocation: RoutesName.splash,
  navigatorKey: _rootNavigatorKey,
  routes: [
    splashRoute(),
    introductionRoute(),
    loginRoute(),
    registerRoute(),
    otpVerificationRoute(),
    homeRoute(),
    userRoute(),
  ],
);
GoRoute splashRoute() => GoRoute(
      name: RoutesName.splash,
      path: RoutesName.splash,
      builder: (BuildContext context, GoRouterState state) => const SplashPage(),
    );

GoRoute introductionRoute() => GoRoute(
      name: RoutesName.introduction,
      path: RoutesName.introduction,
      builder: (BuildContext context, GoRouterState state) => const IntroductionPage(),
    );
GoRoute loginRoute() => GoRoute(
    name: RoutesName.login,
    path: RoutesName.login,
    builder: (BuildContext context, GoRouterState state) => BlocProvider(
          create: (context) => AppFormCubit(),
          child: const LoginPage(),
        ));
GoRoute registerRoute() => GoRoute(
    name: RoutesName.register,
    path: RoutesName.register,
    builder: (BuildContext context, GoRouterState state) => BlocProvider(
          create: (context) => AppFormCubit(),
          child: const RegisterPage(),
        ));
GoRoute otpVerificationRoute() => GoRoute(
    name: RoutesName.otpVerification,
    path: RoutesName.otpVerification,
    builder: (BuildContext context, GoRouterState state) => OTPVerificationPage(extra: state.extra));
GoRoute homeRoute() => GoRoute(
      name: RoutesName.home,
      path: RoutesName.home,
      builder: (BuildContext context, GoRouterState state) => const HomePage(),
    );
GoRoute userRoute() => GoRoute(
      name: RoutesName.user,
      path: RoutesName.user,
      builder: (BuildContext context, GoRouterState state) => const UserPage(),
    );
