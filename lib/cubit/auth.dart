import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/constants/index.dart';
import '/models/index.dart';
import '/utils/index.dart';
import 'index.dart';

class AuthC extends Cubit<AuthS> {
  AuthC() : super(AuthS());

  void check({required BuildContext context}) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(CPref.token) ?? '';

    RepositoryProvider.of<Api>(context).setLanguage(language: context.locale.toString());
    if ((token).isEmpty) {
      emit(state.copyWith(status: AppStatus.fails));
    } else {
      if (context.mounted) {
        try {
          MApi? result = await RepositoryProvider.of<Api>(context).auth.info(token: token);
          if (result != null && result.isSuccess) {
            final MUser user = MUser.fromJson(result.data['userModel']);
            emit(state.copyWith(status: AppStatus.success, user: user));
          } else {
            prefs.remove(CPref.token);
            emit(state.copyWith(status: AppStatus.fails));
          }
        } catch (e) {
          UDialog().showError(text: e.toString());
        }
      }
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(CPref.token);
    emit(state.copyWith(status: AppStatus.fails));
  }

  void save({required data}) async {
    final MUser user = MUser.fromJson(data['userModel']);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(CPref.token, data['tokenString']);
    if (rootNavigatorKey.currentState!.context.mounted) {
      await RepositoryProvider.of<Api>(rootNavigatorKey.currentState!.context).setToken(token: data['tokenString']);
    }

    emit(state.copyWith(status: AppStatus.success, user: user));
  }
}

class AuthS {
  final AppStatus status;
  final MUser? user;

  AuthS({
    this.status = AppStatus.init,
    this.user,
  });

  AuthS copyWith({AppStatus? status, GlobalKey<FormState>? key, MUser? user}) {
    return AuthS(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}
