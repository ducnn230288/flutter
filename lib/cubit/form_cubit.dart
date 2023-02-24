import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/form.dart';
import 'cubit.dart';

class AppFormCubit extends Cubit<AppFormState> {
  AppFormCubit() : super(AppFormState(key: GlobalKey<FormState>(), data: {}, list: []));

  void setList({required List<ModelFormItem> list}) {
    emit(state.copyWith(list: list));
    print(state.list[0].name);
  }

  void saved({String? value, required String name}) {
    state.data[name] = value;
  }

  void savedBool({required String name}) {
    state.data[name] = state.data[name] != null ? !state.data[name] : true;
    emit(state.copyWith(data: state.data));
  }

  void submit() {
    if (state.formKey.currentState?.validate() == true) {
      state.formKey.currentState?.save();
      emit(state.copyWith(status: AppStatus.success, data: state.data));
      print(state.data);
    }
  }
}

class AppFormState {
  final AppStatus status;
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> data;
  final List<ModelFormItem> list;

  AppFormState({
    this.status = AppStatus.inProgress,
    required GlobalKey<FormState> key,
    required this.data,
    required this.list,
  }) : formKey = key;

  AppFormState copyWith(
      {AppStatus? status, GlobalKey<FormState>? key, Map<String, dynamic>? data, List<ModelFormItem>? list}) {
    return AppFormState(
      status: status ?? this.status,
      data: data ?? this.data,
      list: list ?? this.list,
      key: key ?? formKey,
    );
  }
}
