part of 'form_cubit.dart';

enum AppFormStatus { inProgress, success }

class AppFormState {
  final AppFormStatus status;
  final GlobalKey<FormState> formKey;

  AppFormState({
    this.status = AppFormStatus.inProgress,
    required GlobalKey<FormState> key,
  }) : formKey = key;

  AppFormState copyWith({AppFormStatus? status, GlobalKey<FormState>? key}) {
    return AppFormState(
      status: status ?? this.status,
      key: key ?? formKey,
    );
  }
}
