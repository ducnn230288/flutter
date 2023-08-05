import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/models/index.dart';
import '/utils/index.dart';
import 'index.dart';

class BlocC<T> extends Cubit<BlocS<T>> {
  BlocC()
      : super(BlocS<T>(
            key: GlobalKey<FormState>(),
            value: {},
            list: [],
            sort: {},
            page: 1,
            size: 20,
            data: MData<T>(content: [])));

  void setList({required List<MFormItem> list}) {
    emit(state.copyWith(list: list));
  }

  void setData({required MData<T> data, AppStatus status = AppStatus.init}) {
    emit(state.copyWith(data: data, status: status));
  }

  void setStatus({required AppStatus status}) {
    emit(state.copyWith(status: status));
  }

  void setValue({required Map<String, dynamic> value, AppStatus status = AppStatus.init}) {
    emit(state.copyWith(value: {...state.value, ...value}, status: status));
  }

  void addValue({required dynamic value, required String name}) {
    Map<String, dynamic> newValue = {...state.value};
    if (state.value.containsKey(name)) {
      newValue[name] = value;
    } else {
      newValue = {...newValue, name: value};
    }
    emit(state.copyWith(value: newValue));
  }

  void setSize(
      {required int size,
      required Function(Map<String, dynamic> value, int page, int size, Map<String, dynamic> sort) api,
      required Function format}) async {
    final int oldSize = state.size;
    try {
      if (state.status != AppStatus.success){
        emit(state.copyWith(size: size, status: AppStatus.inProcess));
      }
      MApi? result = await api(
        state.value,
        1,
        state.size,
        state.sort,
      );

      if (result != null) {
        MData<T> data = MData.fromJson(result.data, format);
        emit(state.copyWith(data: data, status: AppStatus.success));
      }
    } catch (e) {
      emit(state.copyWith(size: oldSize, status: AppStatus.init));
      debugPrint(e.toString());
    }
  }

  Future<void> setPage(
      {required int page,
      required Function(Map<String, dynamic> value, int page, int size, Map<String, dynamic> sort) api,
      Function? format}) async {
    int oldPage = state.page;
    try {
      if (state.status != AppStatus.success){
        emit(state.copyWith(page: page, status: AppStatus.inProcess));
      }
      MApi? result = await api(
        state.value,
        state.page,
        state.size,
        state.sort,
      );

      if (result != null) {
        MData<T> data = MData.fromJson(result.data, format);
        emit(state.copyWith(data: data, status: AppStatus.success));
      }
    } catch (e) {
      emit(state.copyWith(page: oldPage));
      debugPrint(e.toString());
    }
  }

  void resetPage({required int page, String? name, dynamic value}) {
    emit(state.copyWith(page: page));
    if (name != null && value != null) {
      state.value[name] = value;
    }
  }

  Future<void> increasePage(
      {required Function(Map<String, dynamic> value, int page, int size, Map<String, dynamic> sort) api,
      required Function format}) async {
    emit(state.copyWith(page: state.page + 1));
    try {
      MApi? result = await api(
        state.value,
        state.page,
        state.size,
        state.sort,
      );

      if (result != null) {
        MData<T> data = MData.fromJson(result.data, format);
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
      emit(state.copyWith(page: state.page - 1));
      debugPrint(e.toString());
    }
  }

  void saved({value, required String name}) {
    if (value != null) {
      state.value[name] = value;
    }
  }

  void removeKey({required String name, bool isEmit = false}) {
    state.value.remove(name);
    if (isEmit) {
      emit(state.copyWith(value: state.value));
    }
  }

  void savedBool({required String name}) {
    state.value[name] = state.value[name] != null ? !state.value[name] : true;
    emit(state.copyWith(value: state.value));
  }

  void submit<T>(
      {Function? submit,
      required Function(Map<String, dynamic> value, int page, int size, Map<String, dynamic> sort) api,
      bool getData = false,
      bool onlyApi = false,
      bool showDialog = true,
      bool notification = true,
      String key = 'value',
      Function? format}) async {
    if (getData || onlyApi || state.formKey.currentState?.validate() == true) {
      if (getData) {
        emit(state.copyWith(page: 1));
      }
      UDialog dialogs = UDialog();
      try {
        if (showDialog) {
          await dialogs.delay();
          dialogs.startLoading();
        }
        MApi? result = await api(state.value, state.page, state.size, state.sort);
        if (showDialog) {
          dialogs.stopLoading();
        }
        if (result != null) {
          if (!getData || onlyApi) {
            if (notification) {
              dialogs.showSuccess(
                  text: result.message,
                  onDismiss: (context) {
                    if (submit != null) submit(result.data);
                    emit(state.copyWith(status: AppStatus.success, key: GlobalKey<FormState>()));
                  });
            } else {
              if (submit != null) submit(result.data);
              emit(state.copyWith(status: AppStatus.success, key: GlobalKey<FormState>()));
            }
          } else {
            if (format != null) {
              dynamic data = MData.fromJson(result.data, format);
              if (submit != null) submit(data);
              emit(state.copyWith(status: AppStatus.success, data: data));
            } else {
              if (submit != null) submit(result.data);
              emit(state.copyWith(status: AppStatus.success, value: {key: result.data}));
            }
          }
        }
      } catch (e) {
        dialogs.stopLoading();
        dialogs.showError(text: e.toString());
      }
    }
  }
}

class BlocS<T> {
  final AppStatus status;
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> value;
  final List<MFormItem> list;
  final Map<String, dynamic> sort;
  final int page;
  final int size;
  final MData<T> data;

  BlocS({
    this.status = AppStatus.init,
    required GlobalKey<FormState> key,
    required this.value,
    required this.list,
    required this.sort,
    required this.page,
    required this.size,
    required this.data,
  }) : formKey = key;

  BlocS<T> copyWith({
    AppStatus? status,
    GlobalKey<FormState>? key,
    Map<String, dynamic>? value,
    List<MFormItem>? list,
    Map<String, dynamic>? sort,
    int? page,
    int? size,
    MData<T>? data,
  }) {
    return BlocS<T>(
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
