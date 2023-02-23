part of 'form_cubit.dart';

enum AppFormStatus { inProgress, success }

class AppFormState {
  final AppFormStatus status;
  final GlobalKey<FormState> formKey;
  final Map<String, String> formData;

  AppFormState({
    this.status = AppFormStatus.inProgress,
    required GlobalKey<FormState> key,
    required this.formData,
  }) : formKey = key;

  AppFormState copyWith({AppFormStatus? status, GlobalKey<FormState>? key, Map<String, String>? formData}) {
    return AppFormState(
      status: status ?? this.status,
      formData: formData ?? this.formData,
      key: key ?? formKey,
    );
  }
}
