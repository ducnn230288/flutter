import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'form_state.dart';

class AppFormCubit extends Cubit<AppFormState> {
  AppFormCubit() : super(AppFormState(key: GlobalKey<FormState>()));

  final Map<String, String> _formData = {};

  String? validateEmail(String? value) {
    if (value != null && value.isEmpty) {
      return "Please write your email";
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value != null && value.isEmpty) {
      return "Please write your password";
    }

    return null;
  }

  void onSaved({String? value, required String name}) {
    if (value != null) {
      _formData[name] = value;
    }
  }

  void onSavedEmail(String? email) {
    if (email != null) {
      _formData['email'] = email;
    }
  }

  void onSubmitTap() {
    if (state.formKey.currentState?.validate() == true) {
      state.formKey.currentState?.save();
      emit(state.copyWith(status: AppFormStatus.success));
    }
  }
}
