import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/constants/index.dart';
import '/models/index.dart';
import 'cubit.dart';

class AppAuthCubit extends Cubit<AppAuthState> {
  AppAuthCubit() : super(AppAuthState());

  void check() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(Prefs.token);

    if ((token ?? "").isEmpty) {
      emit(state.copyWith(status: AppStatus.fails));
    } else {}
  }

  void save({required data}) async {
    print(data);
    // final prefs = await SharedPreferences.getInstance();
    // prefs.setString(Prefs.token, 'value');
  }
}

class AppAuthState {
  final AppStatus status;
  final Map<String, dynamic>? data;

  AppAuthState({
    this.status = AppStatus.init,
    this.data,
  });

  AppAuthState copyWith(
      {AppStatus? status, GlobalKey<FormState>? key, Map<String, dynamic>? data, List<ModelFormItem>? list}) {
    return AppAuthState(
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }
}
