import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/cubit/index.dart';
import '/utils/index.dart';

class BlocWidget extends StatelessWidget {
  BlocWidget({super.key, required this.child});

  final Widget child;

  final Api _api = Api();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _api,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppFormCubit>(
            create: (BuildContext context) => AppFormCubit(api: _api),
          ),
        ],
        child: child,
      ),
    );
  }
}