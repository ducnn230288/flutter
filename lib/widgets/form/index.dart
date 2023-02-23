import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/index.dart';
import '../../models/index.dart';
import 'input.dart';
import 'select.dart';

class WidgetFormNotifier extends ChangeNotifier {
  dynamic dataForm = {};
  final formKey = GlobalKey<FormState>();
}

class WidgetForm extends StatelessWidget {
  final List<ModelFormItem> list;

  const WidgetForm({Key? key, required this.list}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppFormCubit, AppFormState>(
        listenWhen: (_, current) => current.status == AppFormStatus.success,
        listener: (context, state) => print(state.formData),
        builder: (context, state) {
          return Form(
            key: state.formKey,
            child: Column(
              children: <Widget>[
                ...List.generate(list.length, (index) {
                  ModelFormItem item = list[index];
                  switch (item.type) {
                    // case 'upload':
                    //   return WidgetUpload(
                    //     label: item.label,
                    //   );
                    case 'select':
                      return item.show
                          ? WidgetSelect(
                              label: item.label,
                              value: item.value != '' ? item.value : null,
                              space: index != list.length - 1,
                              required: item.required,
                              enabled: item.enabled,
                              icon: item.icon,
                              items: item.items,
                              onChanged: (value) {
                                context.read<AppFormCubit>().onSaved(value: value, name: item.name);
                                // notifier.dataForm[item.name] = value;
                                // if (item.onChange != null) {
                                //   item.onChange!(value);
                                // }
                              },
                            )
                          : Container();
                    default:
                      return item.show
                          ? WidgetInput(
                              label: item.label,
                              value: item.value,
                              space: index != list.length - 1,
                              maxLines: item.maxLines,
                              required: item.required,
                              enabled: item.enabled,
                              password: item.password,
                              number: item.number,
                              placeholder: item.placeholder,
                              onChanged: (value) {
                                context.read<AppFormCubit>().onSaved(value: value, name: item.name);
                                // notifier.dataForm[item.name] = text;
                                // if (item.onChange != null) {
                                //   item.onChange!(value);
                                // }
                              },
                              onTap: item.onTap,
                              icon: item.icon,
                              suffix: item.suffix,
                            )
                          : Container();
                  }
                }),
              ],
            ),
          );
        });
  }
}
