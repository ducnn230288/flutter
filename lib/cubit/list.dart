import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'index.dart';

class AppListCubit extends Cubit<AppListState> {
  AppListCubit() : super(AppListState(key: GlobalKey<FormState>(), data: {}, list: []));

  void setList<T>({required List list, required Function format}) {
    List<T> listNew = <T>[];
    for (var i = 0; i < list.length; i++) {
      listNew.add(format(list[i]));
    }
    emit(state.copyWith(list: listNew));
  }
}

class AppListState {
  final AppStatus status;
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> data;
  final List list;

  AppListState({
    this.status = AppStatus.init,
    required GlobalKey<FormState> key,
    required this.data,
    required this.list,
  }) : formKey = key;

  AppListState copyWith({AppStatus? status, GlobalKey<FormState>? key, Map<String, dynamic>? data, List? list}) {
    return AppListState(
      status: status ?? this.status,
      data: data ?? this.data,
      list: list ?? this.list,
      key: key ?? formKey,
    );
  }
}
