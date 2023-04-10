import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/constants/index.dart';
import '/cubit/index.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthC>().check(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColor.primary,
      body: BlocConsumer<AuthC, AuthS>(
          listenWhen: (oldState, newState) => newState.status != AppStatus.init,
          listener: (context, state) =>
              GoRouter.of(context).goNamed(state.status == AppStatus.fails ? CRoute.introduction : CRoute.home),
          builder: (context, state) => Center(
                child: CIcon.logoWhite,
              )),
    );
  }
}
