import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/cubit/index.dart';
import '/models/index.dart';
import 'date.dart';
import 'input.dart';
import 'select.dart';

class WidgetForm extends StatelessWidget {
  final List<ModelFormItem> list;

  const WidgetForm({Key? key, required this.list}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Map<String, TextEditingController> listController = {};
    list.forEach((item) => listController[item.name] = TextEditingController());
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
                          controller: listController[item.name] ?? TextEditingController(),
                          label: item.label,
                          value: item.value,
                          space: index != state.list.length - 1,
                          maxLines: item.maxLines,
                          required: item.required,
                          enabled: item.enabled,
                          onChanged: (value) {
                            if (item.onChange != null) {
                              item.onChange!(value);
                            }
                            context.read<AppFormCubit>().saved(value: value, name: item.name);
                          },
                          icon: item.icon,
                          format: item.format ?? () {},
                          api: item.api ?? () {},
                          itemSelect: item.itemSelect ?? () {},
                          showSearch: item.showSearch ?? true,
                          selectLabel: item.selectLabel ?? () {},
                          selectValue: item.selectValue ?? () {},
                          items: item.items,
                        )
                      : Container();
                case 'date':
                  return item.show
                      ? WidgetDate(
                          controller: listController[item.name] ?? TextEditingController(),
                          label: item.label,
                          value: item.value,
                          space: index != state.list.length - 1,
                          maxLines: item.maxLines,
                          required: item.required,
                          enabled: item.enabled,
                          onChanged: (value) {
                            if (item.onChange != null) {
                              item.onChange!(value);
                            }
                            context.read<AppFormCubit>().saved(value: value, name: item.name);
                          },
                          icon: item.icon,
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
                          onChanged: (value) {
                            if (item.onChange != null) {
                              item.onChange!(value);
                            }
                            context.read<AppFormCubit>().saved(value: value, name: item.name);
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
