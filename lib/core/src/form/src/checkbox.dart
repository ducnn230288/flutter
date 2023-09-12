import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/constants/index.dart';
import '/cubit/bloc.dart';

class WCheckbox extends FormField<bool> {
  WCheckbox({
    super.key,
    required FormFieldSetter<bool> onChanged,
    required String name,
    required Widget child,
    required bool required,
  }) : super(
            onSaved: onChanged,
            validator: (value) {
              if (required && value != true) {
                return 'widgets.form.input.Please check'.tr();
              }
            },
            initialValue: false,
            builder: (FormFieldState<bool> state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 35,
                    child: BlocBuilder<BlocC, BlocS>(
                      builder: (context, stateC) {
                        late final cubit = context.read<BlocC>();
                        void setValue(bool? _) {
                          final value = stateC.value[name] == null ||
                              stateC.value[name] == false;
                          state.didChange(value);
                          state.validate();
                          cubit.saved(value: value, name: name);
                          onChanged(value);
                        }

                        return TextButton(
                            onPressed: () => setValue(false),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    side: BorderSide(
                                        width: 1,
                                        color: state.hasError
                                            ? CColor.danger
                                            : CColor.primary),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    value: stateC.value[name] ?? false,
                                    onChanged: setValue,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                child,
                              ],
                            ));
                      },
                    ),
                  ),
                  state.hasError
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: CSpace.medium),
                          child: Text(
                            state.errorText!,
                            style: TextStyle(
                                fontSize: CFontSize.caption2,
                                color: CColor.danger),
                          ),
                        )
                      : const SizedBox()
                ],
              );
            });
}