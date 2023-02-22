import 'package:flutter/material.dart';

import '/pages.dart';
// import 'package:flutter_bloc/src/bloc_provider.dart';

class RoutesName {
  static const String homePage = '/home-page';

  static const String introductionPage = '/introduction-page';
  static const String loginPage = '/login-page';
  static const String registerPage = '/register-page';
  static const String otpVerificationPage = '/otp-verification-page';
}

class RouteGenerator {
  static Route generateRoute(RouteSettings settings) {
    String routeName = settings.name!;
    final dynamic arguments = settings.arguments;
    switch (routeName) {
      // case RoutesName.loginPage:
      //   return _GeneratePageRoute(
      //     widget: BlocProvider<LoginCubit>(
      //       create: (context) => LoginCubit(context),
      //       child: const LoginPage(),
      //     ),
      //     routeName: routeName,
      //   );
      case RoutesName.homePage:
        return _GeneratePageRoute(
          widget: const HomePage(),
          routeName: routeName,
        );
      case RoutesName.otpVerificationPage:
        return _GeneratePageRoute(
          widget: OTPVerificationPage(
            status: arguments,
          ),
          routeName: routeName,
        );
      case RoutesName.registerPage:
        return _GeneratePageRoute(
          widget: const RegisterPage(),
          routeName: routeName,
        );
      case RoutesName.loginPage:
        return _GeneratePageRoute(
          widget: const LoginPage(),
          routeName: routeName,
        );
      default:
        return _GeneratePageRoute(widget: const IntroductionPage(), routeName: routeName);
    }
  }
}

class _GeneratePageRoute extends PageRouteBuilder {
  final Widget widget;
  final String routeName;
  final bool exitApp;

  _GeneratePageRoute({
    required this.widget,
    required this.routeName,
    this.exitApp = false,
  }) : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
            return WillPopScope(
              onWillPop: () async {
                if (exitApp) {
                  print('exitApp');
                  // return false;
                }
                return true;
              },
              child: widget,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder:
              (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
            return SlideTransition(
              textDirection: TextDirection.ltr,
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}
