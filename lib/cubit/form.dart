import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/models/index.dart';
import '/utils/index.dart';
import 'index.dart';

class AppFormCubit extends Cubit<AppFormState> {
  AppFormCubit()
      : super(AppFormState(
            key: GlobalKey<FormState>(),
            value: {},
            list: [],
            sort: {},
            page: 1,
            size: 20,
            data: ModelData(content: [])));

  void setList({required List<ModelFormItem> list}) {
    emit(state.copyWith(list: list));
  }

  void setData({required ModelData data}) {
    emit(state.copyWith(data: data));
  }

  void setStatus({required AppStatus status}) {
    emit(state.copyWith(status: status));
  }

  void setSize({required int size, required Function api, required AppAuthCubit auth, required Function format}) async {
    final int oldSize = state.size;
    try {
      emit(state.copyWith(size: size));
      ModelApi? result = await api(
        state.value,
        auth.logout,
        state.page,
        state.size,
        state.sort,
      );

      if (result != null) {
        ModelData data = ModelData.fromJson(result.data, format);
        emit(state.copyWith(data: data));
      }
    } catch (e) {
      emit(state.copyWith(size: oldSize));
      print(e.toString());
    }
  }

  void increasePage({required Function api, required AppAuthCubit auth, required Function format}) async {
    emit(state.copyWith(status: AppStatus.init, page: state.page + 1));
    try {
      ModelApi? result = await api(
        state.value,
        auth.logout,
        state.page,
        state.size,
        state.sort,
      );

      if (result != null) {
        ModelData data = ModelData.fromJson(result.data, format);
        if (data.content.isNotEmpty) {
          for (var i = 0; i < data.content.length; i++) {
            state.data.content.add(data.content[i]);
          }
          emit(state.copyWith(status: AppStatus.success, data: state.data));
        } else {
          emit(state.copyWith(status: AppStatus.success, page: state.page - 1));
        }
      }
    } catch (e) {
      emit(state.copyWith(status: AppStatus.success, page: state.page - 1));
      print(e.toString());
    }
  }

  void saved({String? value, required String name}) {
    state.value[name] = value;
  }

  void savedBool({required String name}) {
    state.value[name] = state.value[name] != null ? !state.value[name] : true;
    emit(state.copyWith(value: state.value));
  }

  void submit<T>(
      {required BuildContext context,
      Function? submit,
      required Function api,
      required AppAuthCubit auth,
      bool getData = false,
      Function? format}) async {
    if (getData || state.formKey.currentState?.validate() == true) {
      emit(state.copyWith(page: 1));
      Dialogs dialogs = Dialogs(context);
      try {
        dialogs.startLoading();
        ModelApi? result = await api(
          state.value,
          auth.logout,
          state.page,
          state.size,
          state.sort,
        );
        dialogs.stopLoading();
        if (result != null) {
          if (result.isSuccess) {
            if (!getData) {
              dialogs.showSuccess(
                  title: result.message,
                  onDismiss: (context) {
                    if (submit != null) submit(result.data);
                    emit(state.copyWith(status: AppStatus.success, value: {}, key: GlobalKey<FormState>()));
                  });
            } else if (format != null) {
              ModelData data = ModelData.fromJson(result.data, format);
              if (submit != null) submit(data);
              emit(state.copyWith(status: AppStatus.success, data: data));
            }
          } else {
            dialogs.showError(text: result.message);
          }
        }
      } catch (e) {
        dialogs.stopLoading();
        dialogs.showError(text: e.toString());
      }
    }
  }
}

class AppFormState {
  final AppStatus status;
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> value;
  final List<ModelFormItem> list;
  final Map<String, dynamic> sort;
  final int page;
  final int size;
  final ModelData data;

  AppFormState({
    this.status = AppStatus.init,
    required GlobalKey<FormState> key,
    required this.value,
    required this.list,
    required this.sort,
    required this.page,
    required this.size,
    required this.data,
  }) : formKey = key;

  AppFormState copyWith({
    AppStatus? status,
    GlobalKey<FormState>? key,
    Map<String, dynamic>? value,
    List<ModelFormItem>? list,
    Map<String, dynamic>? sort,
    int? page,
    int? size,
    ModelData? data,
  }) {
    return AppFormState(
      status: status ?? this.status,
      value: value ?? this.value,
      list: list ?? this.list,
      key: key ?? formKey,
      size: size ?? this.size,
      page: page ?? this.page,
      sort: sort ?? this.sort,
      data: data ?? this.data,
    );
  }
}
