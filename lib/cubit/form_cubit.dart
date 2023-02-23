import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'form_state.dart';

class AppFormCubit extends Cubit<AppFormState> {
  AppFormCubit() : super(AppFormState(key: GlobalKey<FormState>(), formData: {}));
  final Map<String, String> _formData = {};

  String? validateEmail(String? value) {
    if (value != null && value.isEmpty) {
      return "Please write your email";
    }

    return null;
  }

  void onSaved({String? value, required String name}) {
    if (value != null) {
      print(_formData);
      _formData[name] = value;
    }
  }

  void onSubmitTap() {
    if (state.formKey.currentState?.validate() == true) {
      state.formKey.currentState?.save();
      emit(state.copyWith(status: AppFormStatus.success, formData: _formData));
    }
  }
}
