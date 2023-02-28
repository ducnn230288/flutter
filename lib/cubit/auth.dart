import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/constants/index.dart';
import '/models/index.dart';
import '/models/user.dart';
import '/utils/api.dart';
import 'index.dart';

class AppAuthCubit extends Cubit<AppAuthState> {
  AppAuthCubit() : super(AppAuthState());

  void check(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(Prefs.token) ?? '';

    if ((token).isEmpty) {
      emit(state.copyWith(status: AppStatus.fails));
    } else {
      if (context.mounted) {
        ModelApi? result = await RepositoryProvider.of<Api>(context).info(token: token);
        if (result != null && result.isSuccess) {
          final ModelUser user = ModelUser.fromJson(result.data!['userModel']);
          emit(state.copyWith(status: AppStatus.success, user: user));
        } else {
          prefs.remove(Prefs.token);
          emit(state.copyWith(status: AppStatus.fails));
        }
      }
    }
  }

  void save({required data}) async {
    final ModelUser user = ModelUser.fromJson(data['userModel']);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(Prefs.token, data['tokenString']);
    emit(state.copyWith(status: AppStatus.success, user: user));
  }
}

class AppAuthState {
  final AppStatus status;
  final ModelUser? user;

  AppAuthState({
    this.status = AppStatus.init,
    this.user,
  });

  AppAuthState copyWith({AppStatus? status, GlobalKey<FormState>? key, ModelUser? user}) {
    return AppAuthState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}
