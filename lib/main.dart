import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uberentaltest/cubit/auth_cubit.dart';

import '/utils/index.dart';
import 'constants/index.dart';
import 'cubit/form_cubit.dart';
import 'pages/index.dart';

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
            routeInformationProvider: _router.routeInformationProvider,
            routeInformationParser: _router.routeInformationParser,
            routerDelegate: _router.routerDelegate,
          ),
        ));
  }

  final _rootNavigatorKey = GlobalKey<NavigatorState>();

  late final GoRouter _router = GoRouter(
    initialLocation: RoutesName.splash,
    // redirect: (context, state) {
    //   final authState = context.read<AuthCubit>().state;
    //   if (authState is Authorized || state.location.startsWith('/auth')) {
    //     return null;
    //   } else {
    //     return '/auth';
    //   }
    // },
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        name: RoutesName.splash,
        path: RoutesName.splash,
        builder: (BuildContext context, GoRouterState state) => const SplashPage(),
      ),
      GoRoute(
        name: RoutesName.introduction,
        path: RoutesName.introduction,
        builder: (BuildContext context, GoRouterState state) => const IntroductionPage(),
      ),
      GoRoute(
          name: RoutesName.login,
          path: RoutesName.login,
          builder: (BuildContext context, GoRouterState state) => BlocProvider(
                create: (context) => AppFormCubit(),
                child: const LoginPage(),
              )),
      GoRoute(
          name: RoutesName.register,
          path: RoutesName.register,
          builder: (BuildContext context, GoRouterState state) => BlocProvider(
                create: (context) => AppFormCubit(),
                child: const RegisterPage(),
              )),
      GoRoute(
          name: RoutesName.otpVerification,
          path: RoutesName.otpVerification,
          builder: (BuildContext context, GoRouterState state) => OTPVerificationPage(extra: state.extra)),
      GoRoute(
        name: RoutesName.home,
        path: RoutesName.home,
        builder: (BuildContext context, GoRouterState state) => const HomePage(),
      ),
    ],
  );
}
