import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/models/index.dart';
import '/utils/index.dart';
import 'cubit.dart';

class AppFormCubit extends Cubit<AppFormState> {
  AppFormCubit({required this.api}) : super(AppFormState(key: GlobalKey<FormState>(), data: {}, list: []));
  final Api api;

  void setList({required List<ModelFormItem> list}) {
    emit(state.copyWith(list: list));
  }

  void saved({String? value, required String name}) {
    state.data[name] = value;
  }

  void savedBool({required String name}) {
    state.data[name] = state.data[name] != null ? !state.data[name] : true;
    emit(state.copyWith(data: state.data));
  }

  void submit({required BuildContext context}) async {
    if (state.formKey.currentState?.validate() == true) {
      Dialogs dialogs = Dialogs(context);
      dialogs.startLoading();
      ModelApi result = await api.login(body: state.data);
      dialogs.stopLoading();
      if (result.isSuccess) {
        dialogs.showSuccess(
            title: result.message,
            onDismiss: (context) {
              emit(state.copyWith(status: AppStatus.success, data: {}, key: GlobalKey<FormState>()));
            });
      } else {
        dialogs.showError(text: result.message);
      }
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