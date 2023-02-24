import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/cubit/index.dart';
import '/models/index.dart';
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
    context.read<AppFormCubit>().setList(list: list);
    return BlocBuilder<AppFormCubit, AppFormState>(builder: (context, state) {
      return Form(
        key: state.formKey,
        child: Column(
          children: <Widget>[
            ...List.generate(state.list.length, (index) {
              ModelFormItem item = state.list[index];
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
                          space: index != state.list.length - 1,
                          required: item.required,
                          enabled: item.enabled,
                          icon: item.icon,
                          items: item.items,
                          onChanged: (value) {
                            if (item.onChange != null) {
                              item.onChange!(value);
                            }
                            context.read<AppFormCubit>().saved(value: value, name: item.name);
                            // notifier.dataForm[item.name] = value;
                          },
                        )
                      : Container();
                default:
                  return item.show
                      ? WidgetInput(
                          label: item.label,
                          value: item.value,
                          space: index != state.list.length - 1,
                          maxLines: item.maxLines,
                          required: item.required,
                          enabled: item.enabled,
                          password: item.password,
                          number: item.number,
                          placeholder: item.placeholder,
                          onChanged: (value) {
                            if (item.onChange != null) {
                              item.onChange!(value);
                            }
                            context.read<AppFormCubit>().saved(value: value, name: item.name);
                            // notifier.dataForm[item.name] = text;
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
