import 'dart:convert';

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

  Future<void> check({required BuildContext context}) async {
    emit(state.copyWith(status: AppStatus.inProcess));
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(CPref.token) ?? '';

    RepositoryProvider.of<Api>(context)
        .setLanguage(language: context.locale.toString() == 'vi' ? 'vn' : context.locale.toString());

    if ((token).isEmpty) {
      emit(state.copyWith(status: AppStatus.fails));
    } else {
      if (context.mounted) {
        try {
          MApi? result = await RepositoryProvider.of<Api>(context).auth.info(token: token);
          if (result != null && result.isSuccess) {
            result.data['userModel']['listRole'] = result.data['listRole'];
            final MUser user = MUser.fromJson(result.data['userModel']);
            final navigation = await RepositoryProvider.of<Api>(context).navigation.get();
            List<MNavigation> listNavigation = [];
            for (var v in navigation!.data['content']) {
              listNavigation.add(MNavigation.fromJson(v));
            }
            emit(state.copyWith(status: AppStatus.success, user: user, listNavigation: listNavigation));
          } else {
            prefs.remove(CPref.token);
            emit(state.copyWith(status: AppStatus.fails));
          }
        } catch (e) {
          UDialog().showError(text: e.toString());
          emit(state.copyWith(status: AppStatus.fails));
        }
      }
    }
  }

  void error() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(CPref.token);
    prefs.remove(CPref.user);
    emit(state.copyWith(status: AppStatus.fails));
  }

  Future<void> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    await UDialog().delay();
    if (rootNavigatorKey.currentState!.context.mounted) {
      await RepositoryProvider.of<Api>(rootNavigatorKey.currentState!.context).clearHeader(name: 'Authorization');
    }
    emit(state.copyWith(status: AppStatus.init, user: null, zalo: null));
  }

  Future<void> save({required data, required BuildContext context}) async {
    final MUser user = MUser.fromJson(data['userModel']);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(CPref.token, data['tokenString']);
    prefs.setString(CPref.user, jsonEncode(data['userModel']));

    if (rootNavigatorKey.currentState!.context.mounted) {
      await RepositoryProvider.of<Api>(rootNavigatorKey.currentState!.context).setToken(token: data['tokenString']);
    }
    final navigation = await RepositoryProvider.of<Api>(context).navigation.get();
    List<MNavigation> listNavigation = [];
    for (var v in navigation!.data['content']) {
      listNavigation.add(MNavigation.fromJson(v));
    }

    emit(state.copyWith(status: AppStatus.success, user: user, listNavigation: listNavigation));
  }
}

class AuthS {
  final AppStatus status;
  final MUser? user;
  final List<MNavigation>? listNavigation;
  final String? zalo;

  AuthS({
    this.status = AppStatus.init,
    this.user,
    this.listNavigation,
    this.zalo,
  });

  AuthS copyWith({AppStatus? status, GlobalKey<FormState>? key, MUser? user, List<MNavigation>? listNavigation, String? zalo}) {
    return AuthS(
      status: status ?? this.status,
      user: user ?? this.user,
      listNavigation: listNavigation ?? this.listNavigation,
      zalo: zalo ?? this.zalo,
    );
  }
}
