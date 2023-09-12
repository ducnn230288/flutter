import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';

class WForm extends StatefulWidget {
  final List<MFormItem> list;
  final Widget Function(Map<String, Widget> items)? builder;
  final void Function(Map<String, TextEditingController> listController)?
      onInit;
  final void Function(Map<String, TextEditingController> listController)?
      onChangedController;

  const WForm({
    Key? key,
    required this.list,
    this.builder,
    this.onInit,
    this.onChangedController,
  }) : super(key: key);

  @override
  State<WForm> createState() => _WFormState();
}

class _WFormState extends State<WForm> {
  final Map<String, TextEditingController> listController = {};
  late final cubit = context.read<BlocC>();

  @override
  void initState() {
    super.initState();
    setControl();
  }

  void setControl() {
    for (var item in widget.list) {
      listController[item.name] = TextEditingController();
    }
    widget.onInit?.call(listController);
    cubit.setList(list: widget.list);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlocC, BlocS>(builder: (context, state) {
      Map<String, Widget> items = {};
      for (int index = 0; index < widget.list.length; index++) {
        final MFormItem item = state.list[index];
        late Widget child;
        if (item.value != '' &&
            listController[item.name] != null &&
            state.status != AppStatus.success) {
          if (item.type != EFormItemType.upload) {
            if (item.type == EFormItemType.selectMultiple) {
              final List listValue = item.value.split(',');
              if (listValue.length > 1) {
                listController[item.name]!.text =
                    'Đã chọn: ${listValue.length}';
              } else if (item.value.split(',').length > 0) {
                listController[item.name]!.text = listValue[0];
              }
            } else if (item.type != EFormItemType.date) {
              listController[item.name]!.text = item.value ?? '';
            }
          }
          switch (item.type) {
            case EFormItemType.date:
              state.value[item.name] = item.value;
              if (item.mode == DateRangePickerSelectionMode.single) {
                listController[item.name]!.text =
                    Convert.dateLocation(item.value ?? '');
              } else {
                listController[item.name]!.text =
                    Convert.dateTimeMultiple(item.value ?? '');
              }
              break;
            case EFormItemType.select:
            case EFormItemType.time:
              state.value[item.name] = item.code;
              break;
            case EFormItemType.upload:
              state.value[item.name] =
                  item.value?.map((v) => v.toJson()).toList() ?? [];
              break;
            case EFormItemType.selectMultiple:
              state.value[item.name] = item.code.split(',');
              break;
            case EFormItemType.checkbox:
              state.value[item.name] = item.value ?? false;
              break;
            default:
              if (item.number) {
                if (item.value.toString().contains(' ')) {
                  state.value[item.name] =
                      item.value.toString().replaceAll(' ', '');
                } else if (item.formatNumberType ==
                    FormatNumberType.inputFormatters) {
                  state.value[item.name] = item.value;
                  listController[item.name]!.text =
                      Convert.thousands(item.value);
                }
              } else {
                state.value[item.name] = item.value;
              }
          }
        }
        listController[item.name]?.selection = TextSelection.fromPosition(
          TextPosition(offset: listController[item.name]?.text.length ?? 0),
        );

        switch (item.type) {
          case EFormItemType.title:
            child = Container(
              margin: const EdgeInsets.only(bottom: CSpace.small),
              alignment: Alignment.topLeft,
              child: Text(item.label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: CFontSize.title2)),
            );
            break;
          case EFormItemType.checkbox:
            child = WCheckbox(
              name: item.name,
              required: item.required,
              onChanged: (value) {
                if (item.onChange != null) item.onChange!(value);
                cubit.saved(value: value, name: item.name);
              },
              child: item.child!,
            );
            break;
          case EFormItemType.separation:
            child = Container(
              margin: const EdgeInsets.only(
                  bottom: CSpace.small, top: CSpace.small / 2),
              child: Row(
                children: [
                  Text(item.label,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: CColor.black.shade300)),
                  const SizedBox(width: 10),
                  Expanded(child: line())
                ],
              ),
            );
            break;
          case EFormItemType.upload:
            child = WUpload(
              required: item.required,
              uploadType: item.uploadType,
              list: item.value != null && item.value != '' ? item.value : [],
              label: item.label,
              space: index != state.list.length - 1,
              maxQuantity: item.maxQuantity,
              minQuantity: item.minQuantity,
              docType: item.name,
              prefix: item.prefix,
              maxCount: item.maxCountUpload,
              onChanged: (dynamic value) {
                if (item.onChange != null)
                  item.onChange!(
                      item.uploadType == UploadType.single ? value[0] : value);
                cubit.saved(
                    value:
                        item.uploadType == UploadType.single ? value[0] : value,
                    name: item.name);
              },
            );
            break;
          case EFormItemType.select:
            child = item.show
                ? WSelect(
                    controller:
                        listController[item.name] ?? TextEditingController(),
                    label: item.label,
                    name: item.name,
                    hintText: item.hintText,
                    subtitle: item.subtitle,
                    value: item.value ?? '',
                    space: index != state.list.length - 1,
                    maxLines: item.maxLines,
                    required: item.required,
                    enabled: item.enabled,
                    stackedLabel: item.stackedLabel,
                    suffix: item.suffix,
                    onChanged: (value) {
                      widget.onChangedController?.call(listController);
                      if (item.onChange != null) item.onChange!(value);
                      cubit.saved(value: value, name: item.name);
                      item.value = '';
                    },
                    onTap: item.onTap,
                    icon: item.icon,
                    format: item.format,
                    api: item.api ?? (_, __, ___, ____) {},
                    itemSelect:
                        item.itemSelect ?? (dynamic content, int index) {},
                    showSearch: item.showSearch ?? true,
                    selectLabel: item.selectLabel ?? () {},
                    selectValue: item.selectValue ?? () {},
                    items: item.items,
                  )
                : Container();
            break;
          case EFormItemType.selectMultiple:
            child = item.show
                ? WSelectMultiple(
                    controller:
                        listController[item.name] ?? TextEditingController(),
                    name: item.name,
                    label: item.label,
                    hintText: item.hintText,
                    subtitle: item.subtitle,
                    value: item.value ?? '',
                    code: item.code ?? '',
                    space: index != state.list.length - 1,
                    maxLines: item.maxLines,
                    stackedLabel: item.stackedLabel,
                    required: item.required,
                    enabled: item.enabled,
                    onChanged: (value) {
                      widget.onChangedController?.call(listController);
                      if (item.onChange != null) item.onChange!(value);
                      cubit.saved(value: value.split(','), name: item.name);
                    },
                    icon: item.icon,
                    format: item.format,
                    api: item.api ?? (_, __, ___, ____) {},
                    itemSelect:
                        item.itemSelect ?? (dynamic content, int index) {},
                    showSearch: item.showSearch ?? true,
                    selectLabel: item.selectLabel ?? () {},
                    selectValue: item.selectValue ?? () {},
                    items: item.items,
                  )
                : Container();
            break;
          case EFormItemType.date:
            child = item.show
                ? WDate(
                    selectDateType: item.selectDateType,
                    controller:
                        listController[item.name] ?? TextEditingController(),
                    label: item.label,
                    hintText: item.hintText,
                    value: item.mode == DateRangePickerSelectionMode.single
                        ? (item.value ?? '')
                        : (item.value != '' ? item.value.join('|') : ''),
                    subtitle: item.subtitle,
                    space: index != state.list.length - 1,
                    stackedLabel: item.stackedLabel,
                    maxLines: item.maxLines,
                    required: item.required,
                    enabled: item.enabled,
                    onChanged: (value) {
                      dynamic val = value;
                      if (value.contains('|')) {
                        val = value.split('|');
                      }
                      if (item.onChange != null) item.onChange!(val);
                      cubit.saved(value: val, name: item.name);
                      item.value = '';
                    },
                    icon: item.icon,
                    mode: item.mode,
                    showTime: item.showTime,
                  )
                : Container();
            break;
          case EFormItemType.time:
            child = item.show
                ? WTime(
                    controller:
                        listController[item.name] ?? TextEditingController(),
                    label: item.label,
                    hintText: item.hintText,
                    value: item.code ?? '',
                    subtitle: item.subtitle,
                    space: index != state.list.length - 1,
                    maxLines: item.maxLines,
                    required: item.required,
                    enabled: item.enabled,
                    onChanged: (value) {
                      if (item.onChange != null) item.onChange!(value);
                      cubit.saved(value: value, name: item.name);
                      item.value = '';
                    },
                    icon: item.icon,
                  )
                : Container();
            break;
          default:
            // Fix error parse when value is null
            if (item.number &&
                !item.name.toLowerCase().contains('phone') &&
                item.value != '' &&
                item.value != null &&
                item.formatNumberType == FormatNumberType.inputFormatters) {
              listController[item.name]!.text = Convert.thousands(item.value);
            }
            if (item.child != null) {
              child = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.label != '')
                    Container(
                      margin: const EdgeInsets.only(bottom: CSpace.mediumSmall),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: item.label,
                            style: TextStyle(
                              color: CColor.black,
                              fontSize: CFontSize.headline,
                              fontWeight: FontWeight.w600,
                              height: 22 / CFontSize.body,
                            )),
                      ),
                    ),
                  item.child!,
                  SizedBox(
                      height:
                          index != state.list.length - 1 ? CSpace.medium : 0),
                ],
              );
            } else {
              child = item.show
                  ? WInput(
                      controller:
                          listController[item.name] ?? TextEditingController(),
                      label: item.label,
                      hintText: item.hintText,
                      name: item.name,
                      value: item.value ?? '',
                      subtitle: item.subtitle,
                      space: index != state.list.length - 1,
                      formatNumberType: item.formatNumberType,
                      maxLines: item.maxLines,
                      required: item.required,
                      enabled: item.enabled,
                      password: item.password,
                      number: item.number,
                      onChanged: (value) {
                        if (item.onChange != null) item.onChange!(value);
                        cubit.saved(value: value, name: item.name);
                        item.value = '';
                      },
                      onTap: item.onTap,
                      icon: item.icon,
                      suffix: item.suffix,
                    )
                  : Container();
            }

            break;
        }

        items[item.name == '' ? '$index' : item.name] = child;
      }

      return Form(
          key: state.formKey,
          child: widget.builder?.call(items) ??
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ...items.entries.map((e) => e.value).toList()
                ],
              ));
    });
  }
}