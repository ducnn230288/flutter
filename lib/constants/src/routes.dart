import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/cubit/index.dart';
import '/models/index.dart';
import '/pages/index.dart';

class CRoute {
  static const String home = '/home';
  static const String internalUser = 'internal-user';
  static const String customerUser = 'customer-user';
  static const String createInternalUser = 'create-internal-user';
  static const String createCustomerUser = 'create-customer-user';
  static const String customerUserDetails = 'customer-user-details';
  static const String internalUserDetails = 'internal-user-details';
  static const String splash = '/splash';
  static const String introduction = '/introduction';
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgot-password';
  static const String otpVerification = 'otp-verification';
  static const String resetPassword = 'reset-password';
  static const String myAccountInfo = 'my-account-info';
  static const String myAccountPass = 'my-account-password';
}

final rootNavigatorKey = GlobalKey<NavigatorState>();
final GoRouter routes = GoRouter(
  initialLocation: CRoute.splash,
  navigatorKey: rootNavigatorKey,
  routes: <RouteBase>[
    splashRoute(),
    introductionRoute(),
    homeRoute(),
  ],
);

GoRoute splashRoute() => GoRoute(
      name: CRoute.splash,
      path: CRoute.splash,
      builder: (BuildContext context, GoRouterState state) =>
          const SplashPage(),
    );

GoRoute introductionRoute() => GoRoute(
        name: CRoute.introduction,
        path: CRoute.introduction,
        builder: (BuildContext context, GoRouterState state) =>
            const IntroductionPage(),
        routes: <RouteBase>[
          GoRoute(
              name: CRoute.login,
              path: CRoute.login,
              builder: (BuildContext context, GoRouterState state) =>
                  blocForm(child: const LoginPage()),
              routes: <RouteBase>[
                GoRoute(
                    name: CRoute.forgotPassword,
                    path: CRoute.forgotPassword,
                    builder: (BuildContext context, GoRouterState state) =>
                        blocForm(child: const ForgotPassword()),
                    routes: <RouteBase>[
                      GoRoute(
                          name: CRoute.otpVerification,
                          path: CRoute.otpVerification,
                          builder:
                              (BuildContext context, GoRouterState state) =>
                                  blocForm(
                                      child: OTPVerificationPage(
                                          email: state.queryParams['email']!)),
                          routes: <RouteBase>[
                            GoRoute(
                              name: CRoute.resetPassword,
                              path: CRoute.resetPassword,
                              builder: (BuildContext context,
                                      GoRouterState state) =>
                                  blocForm(
                                      child: ResetPassword(
                                          resetPasswordToken: state.queryParams[
                                              'resetPasswordToken']!)),
                            )
                          ])
                    ])
              ]),
          GoRoute(
              name: CRoute.register,
              path: CRoute.register,
              builder: (BuildContext context, GoRouterState state) => blocForm(
                    child: const RegisterPage(),
                  ))
        ]);

blocForm<T>({required Widget child}) => BlocListener<AuthC, AuthS>(
    listenWhen: (oldState, newState) => newState.status == AppStatus.fails,
    listener: (context, state) =>
        GoRouter.of(context).goNamed(CRoute.introduction),
    child: BlocProvider(
      create: (context) => BlocC<T>(),
      child: child,
    ));

GoRoute homeRoute() => GoRoute(
        name: CRoute.home,
        path: CRoute.home,
        builder: (BuildContext context, GoRouterState state) =>
            blocForm(child: const HomePage()),
        routes: <RouteBase>[
          GoRoute(
            name: CRoute.myAccountInfo,
            path: CRoute.myAccountInfo,
            builder: (BuildContext context, GoRouterState state) =>
                blocForm(child: const MyAccountInfo()),
          ),
          GoRoute(
              name: CRoute.myAccountPass,
              path: CRoute.myAccountPass,
              builder: (BuildContext context, GoRouterState state) =>
                  blocForm(child: const MyAccountPass())),
          GoRoute(
            name: CRoute.internalUser,
            path: CRoute.internalUser,
            builder: (BuildContext context, GoRouterState state) =>
                blocForm<MUser>(child: const User()),
            routes: <RouteBase>[
              GoRoute(
                name: CRoute.createInternalUser,
                path: CRoute.createInternalUser,
                builder: (BuildContext context, GoRouterState state) =>
                    blocForm(
                  child: CreateUser(
                    data: state.queryParams['data'] != null
                        ? MUser.fromJson(jsonDecode(state.queryParams['data']!))
                        : null,
                    formType: FormType.values.firstWhere(
                      (element) =>
                          element.name == state.queryParams['formType']!,
                    ),
                  ),
                ),
              ),
              GoRoute(
                name: CRoute.internalUserDetails,
                path: CRoute.internalUserDetails,
                builder: (BuildContext context, GoRouterState state) =>
                    blocForm(child: UserDetails(id: state.queryParams['id']!)),
              ),
            ],
          ),
          GoRoute(
              name: CRoute.customerUser,
              path: CRoute.customerUser,
              builder: (BuildContext context, GoRouterState state) =>
                  blocForm<MUser>(child: const User()),
              routes: <RouteBase>[
                GoRoute(
                  name: CRoute.createCustomerUser,
                  path: CRoute.createCustomerUser,
                  builder: (BuildContext context, GoRouterState state) =>
                      blocForm(
                    child: CreateUser(
                      data: state.queryParams['data'] != null
                          ? MUser.fromJson(
                              jsonDecode(state.queryParams['data']!))
                          : null,
                      formType: FormType.values.firstWhere(
                        (element) =>
                            element.name == state.queryParams['formType']!,
                      ),
                    ),
                  ),
                ),
                GoRoute(
                  name: CRoute.customerUserDetails,
                  path: CRoute.customerUserDetails,
                  builder: (BuildContext context, GoRouterState state) =>
                      blocForm(
                          child: UserDetails(id: state.queryParams['id']!)),
                ),
              ]),
        ]);
