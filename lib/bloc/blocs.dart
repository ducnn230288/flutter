import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/cubit/index.dart';
import '/utils.dart';

class BlocWidget extends StatelessWidget {
  BlocWidget({super.key, required this.child});

  final Widget child;

  final Repository _repository = Repository();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _repository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppFormCubit>(
            create: (BuildContext context) => AppFormCubit(),
          ),
        ],
        child: child,
      ),
    );
  }
}
