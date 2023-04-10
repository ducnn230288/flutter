import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';
import 'date.dart';
import 'input.dart';
import 'select.dart';
import 'select_multiple.dart';
import 'time.dart';
import 'upload.dart';

class WForm extends StatefulWidget {
  final List<MFormItem> list;

  const WForm({Key? key, required this.list}) : super(key: key);

  @override
  State<WForm> createState() => _WFormState();
}

class _WFormState extends State<WForm> {
  final Map<String, TextEditingController> listController = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setControl();
  }

  void setControl() {
    for (var item in widget.list) {
      listController[item.name] = TextEditingController();
    }
    context.read<BlocC>().setList(list: widget.list);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlocC, BlocS>(builder: (context, state) {
      return Form(
        key: state.formKey,
        child: Column(
          children: <Widget>[
            ...List.generate(state.list.length, (index) {
              final MFormItem item = state.list[index];
              if (item.value != '' && listController[item.name] != null && state.status != AppStatus.success) {
                if (item.type != 'upload') {
                  if (item.type == 'select_multiple') {
                    final List listValue = item.value.split(',');
                    if (listValue.length > 1) {
                      listController[item.name]!.text = 'Chọn nhiều...';
                    } else if (item.value.split(',').length > 0) {
                      listController[item.name]!.text = listValue[0];
                    }
                  } else {
                    listController[item.name]!.text = item.value ?? '';
                  }
                }
                switch (item.type) {
                  case 'select':
                  case 'date':
                  case 'time':
                    state.value[item.name] = item.code;
                    break;
                  case 'upload':
                    state.value[item.name] = item.value?.map((v) => v.toJson()).toList() ?? [];
                    break;
                  case 'select_multiple':
                    state.value[item.name] = item.code.split(',');
                    break;
                  default:
                    state.value[item.name] = item.value;
                }
              }
              switch (item.type) {
                case 'upload':
                  return WUpload(
                    list: item.value ?? [],
                    label: item.label,
                    space: index != state.list.length - 1,
                    maxQuantity: item.maxQuantity,
                    minQuantity: item.minQuantity,
                    docType: item.name,
                    onChanged: (value) {
                      if (item.onChange != null) {
                        item.onChange!(value);
                      }
                      context.read<BlocC>().saved(value: value, name: item.name);
                    },
                  );
                case 'select':
                  return item.show
                      ? WSelect(
                          controller: listController[item.name] ?? TextEditingController(),
                          label: item.label,
                          value: item.value ?? '',
                          space: index != state.list.length - 1,
                          maxLines: item.maxLines,
                          required: item.required,
                          enabled: item.enabled,
                          onChanged: (value) {
                            if (item.onChange != null) {
                              item.onChange!(value);
                            }
                            context.read<BlocC>().saved(value: value, name: item.name);
                          },
                          icon: item.icon,
                          format: item.format,
                          api: item.api ??
                              (Map<String, dynamic> value, int page, int size, Map<String, dynamic> sort) {},
                          itemSelect: item.itemSelect ?? (dynamic content, int index) {},
                          showSearch: item.showSearch ?? true,
                          selectLabel: item.selectLabel ?? () {},
                          selectValue: item.selectValue ?? () {},
                          items: item.items,
                        )
                      : Container();
                case 'select_multiple':
                  return item.show
                      ? WSelectMultiple(
                          controller: listController[item.name] ?? TextEditingController(),
                          name: item.name,
                          label: item.label,
                          value: item.value ?? '',
                          code: item.code ?? '',
                          space: index != state.list.length - 1,
                          maxLines: item.maxLines,
                          required: item.required,
                          enabled: item.enabled,
                          onChanged: (value) {
                            //value dạng chuỗi, VD: "key, code"
                            if (item.onChange != null) {
                              item.onChange!(value);
                            }
                            context.read<BlocC>().saved(value: value.split(','), name: item.name);
                          },
                          icon: item.icon,
                          format: item.format,
                          api: item.api ??
                              (Map<String, dynamic> value, int page, int size, Map<String, dynamic> sort) {},
                          itemSelect: item.itemSelect ?? (dynamic content, int index) {},
                          showSearch: item.showSearch ?? true,
                          selectLabel: item.selectLabel ?? () {},
                          selectValue: item.selectValue ?? () {},
                          items: item.items,
                        )
                      : Container();
                case 'date':
                  return item.show
                      ? WDate(
                          controller: listController[item.name] ?? TextEditingController(),
                          label: item.label,
                          value: item.code ?? '',
                          space: index != state.list.length - 1,
                          maxLines: item.maxLines,
                          required: item.required,
                          enabled: item.enabled,
                          onChanged: (value) {
                            if (item.onChange != null) {
                              item.onChange!(value);
                            }
                            context.read<BlocC>().saved(value: value, name: item.name);
                          },
                          icon: item.icon,
                        )
                      : Container();
                case 'time':
                  return item.show
                      ? WTime(
                          controller: listController[item.name] ?? TextEditingController(),
                          label: item.label,
                          value: item.code ?? '',
                          space: index != state.list.length - 1,
                          maxLines: item.maxLines,
                          required: item.required,
                          enabled: item.enabled,
                          onChanged: (value) {
                            if (item.onChange != null) {
                              item.onChange!(value);
                            }
                            context.read<BlocC>().saved(value: value, name: item.name);
                          },
                          icon: item.icon,
                        )
                      : Container();
                default:
                  // Fix error parse when value is null
                  if (item.number &&
                      !item.name.toLowerCase().contains('phone') &&
                      item.value != '' &&
                      item.value != null) {
                    listController[item.name]!.text = Convert.price(double.parse(item.value), '');
                  }
                  return item.show
                      ? WInput(
                          controller: listController[item.name] ?? TextEditingController(),
                          label: item.label,
                          name: item.name,
                          value: item.value ?? '',
                          space: index != state.list.length - 1,
                          maxLines: item.maxLines,
                          required: item.required,
                          enabled: item.enabled,
                          password: item.password,
                          number: item.number,
                          onChanged: (value) {
                            if (item.onChange != null) item.onChange!(value);
                            if (state.value[item.name] != null && item.value != '') item.value = '';
                            context.read<BlocC>().saved(value: value, name: item.name);
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
