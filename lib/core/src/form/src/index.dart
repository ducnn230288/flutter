import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';

class WForm<T> extends StatefulWidget {
  final List<MFormItem> list;
  final List<String> listKeyChanged;
  final Widget Function(Map<String, Widget> items)? builder;
  final void Function(Map<String, TextEditingController> listController)? onInit;

  const WForm({
    super.key,
    required this.list,
    this.listKeyChanged = const [],
    this.builder,
    this.onInit,
  });

  @override
  State<WForm> createState() => _WFormState<T>();
}

class _WFormState<T> extends State<WForm> {
  final Map<String, TextEditingController> listController = {};
  final Map<String, GlobalKey> listKey = {};
  final List<String> listTrickMap = [];
  late final cubit = context.read<BlocC<T>>();
  late Timer _t;
  late Timer _tChange;
  @override
  void initState() {
    super.initState();
    setControl();
  }

  void setControl() {
    for (var item in widget.list) {
      listController[item.name] = TextEditingController();
      listKey[item.name] = GlobalKey();
      if (item.type == EFormItemType.map) listTrickMap.add(item.name);
    }
    widget.onInit?.call(listController);
    cubit.setList(list: widget.list);
    _tChange = Timer(const Duration(milliseconds: 1), () {});
    _t = Timer(const Duration(milliseconds: 500), () {});
  }

  void onChangedController() {
    for (var name in listTrickMap) {
      if (listKey[name]?.currentState != null) (listKey[name]!.currentState as WInputMapState<T>).setAddress(listController);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlocC<T>, BlocS<T>>(builder: (context, state) {
      Map<String, Widget> items = {};
      for (int index = 0; index < widget.list.length; index++) {
        final MFormItem item = state.list[index];
        late Widget child;
        if (((state.value[item.name] != null && state.value[item.name] != '') || (item.value != null && item.value != '')) && listController[item.name] != null && state.status != AppStatus.success) {
          switch (item.type) {
            case EFormItemType.date:
              state.value[item.name] = state.value[item.name] ?? item.value;
              Timer(const Duration(microseconds: 1), () => listController[item.name]!.text =
              item.mode == DateRangePickerSelectionMode.single
                  ? Convert.dateLocation(state.value[item.name] ?? '')
                  : Convert.dateTimeMultiple(state.value[item.name] ?? ''));
              break;
            case EFormItemType.select:
              state.value[item.name] = state.value[item.name] ?? item.code;
              Timer(const Duration(microseconds: 1), () => listController[item.name]!.text = item.value);
              break;
            case EFormItemType.time:
              state.value[item.name] = state.value[item.name] ?? item.value;
              Timer(const Duration(microseconds: 1), () => listController[item.name]!.text = Convert.hours(state.value[item.name] ?? ''));
              break;
            case EFormItemType.upload:
              state.value[item.name] = state.value[item.name] ?? (item.value?.map((v) => item.value is List<String> ? {'fileUrl': v, 'docType': ''} : v.toJson()).toList()) ?? [];
              break;
            case EFormItemType.selectMultiple:
              state.value[item.name] = state.value[item.name] ?? item.code;
              if (item.value.length == 0) Timer(const Duration(microseconds: 1), () => listController[item.name]!.text = item.value.length > 1 ? 'Đã chọn: ${item.value.length}' : item.value[0]);
              break;
            case EFormItemType.checkbox:
              state.value[item.name] = state.value[item.name] ?? item.value ?? false;
              break;
            default:
              if (item.keyBoard == EFormItemKeyBoard.number) {
                state.value[item.name] =
                    state.value[item.name] ?? (item.value.toString().contains('.') ? item.value.toString().replaceAll('.', '') : item.value);
                Timer(const Duration(microseconds: 1), () => listController[item.name]!.text =
                item.formatNumberType == FormatNumberType.inputFormatters && !state.value[item.name].toString().contains('.')
                    ? Convert.thousands(state.value[item.name].toString())
                    : state.value[item.name]);
              } else {
                state.value[item.name] = state.value[item.name] ?? item.value;
                if (item.type != EFormItemType.map) Timer(const Duration(microseconds: 1), () => listController[item.name]!.text = state.value[item.name]);
              }
          }
        }
        Timer(const Duration(microseconds: 1), () => listController[item.name]?.selection = TextSelection.fromPosition(
          TextPosition(offset: listController[item.name]?.text.length ?? 0),
        ));

        switch (item.type) {
          case EFormItemType.map:
            child = item.show ? WInputMap<T>(
              key: listKey[item.name],
              value: state.value[item.name],
              name: item.name,
              label: item.label,
              onCondition: item.onCondition,
            ) : Container();
            break;
          case EFormItemType.title:
            child = item.show ? Container(
              margin: const EdgeInsets.only(bottom: CSpace.sm),
              alignment: Alignment.topLeft,
              child: Text(item.label, key: ValueKey(item.label), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: CFontSize.xl2)),
            ) : Container();
            break;
          case EFormItemType.checkbox:
            child = WCheckbox<T>(
              key: listKey[item.name],
              value: state.value[item.name] ?? false,
              name: item.name,
              required: item.required,
              onChanged: (value) {
                _tChange.cancel();
                if (item.onChange != null) _tChange = Timer(Duration(milliseconds: listTrickMap.isNotEmpty ? 1200 : 0), () { item.onChange!(value, listController); });
                cubit.saved(value: value, name: item.name);
              },
              child: item.child!,
            );
            break;
          case EFormItemType.separation:
            child = Container(
              margin: const EdgeInsets.only(bottom: CSpace.sm, top: CSpace.sm / 2),
              child: Row(
                children: [
                  Text(item.label, style: TextStyle(fontWeight: FontWeight.w400, color: CColor.black.shade300)),
                  const SizedBox(width: 10),
                  Expanded(child: line())
                ],
              ),
            );
            break;
          case EFormItemType.upload:
            child = FUpload<T>(
              key: listKey[item.name],
              required: item.required,
              name: item.name,
              uploadType: item.uploadType,
              list: state.value[item.name] ?? [],
              label: item.label,
              space: index != state.list.length - 1,
              maxQuantity: item.maxQuantity ?? 1,
              minQuantity: item.minQuantity ?? 1,
              docType: item.name,
              prefix: item.prefix,
              maxCount: item.maxCountUpload,
              onDelete: item.onDelete,
              onChanged: (dynamic value) {
                _tChange.cancel();
                if (item.onChange != null) _tChange = Timer(Duration(milliseconds: listTrickMap.isNotEmpty ? 1200 : 0), () { item.onChange!(value, listController); });
                cubit.saved(value: value, name: item.name);
              },
            );
            break;
          case EFormItemType.select:
            child = item.show
                ? WSelect<T>(
                    key: listKey[item.name],
                    controller: listController[item.name] ?? TextEditingController(),
                    label: item.label,
                    name: item.name,
                    hintText: item.hintText,
                    subtitle: item.subtitle,
                    value: state.value[item.name].toString(),
                    space: index != state.list.length - 1,
                    maxLines: item.maxLines,
                    required: item.required,
                    enabled: item.enabled,
                    stackedLabel: item.stackedLabel,
                    suffix: item.suffix,
                    onChanged: (value) {
                      item.value = listController[item.name]!.text;
                      item.code = value;
                      _tChange.cancel();
                      if (item.onChange != null) _tChange = Timer(Duration(milliseconds: listTrickMap.isNotEmpty ? 1200 : 0), () { item.onChange!(value, listController); });
                      cubit.saved(value: value, name: item.name);
                      _t.cancel();
                      if (widget.listKeyChanged.contains(item.name)) _t = Timer(const Duration(milliseconds: 1), () { onChangedController(); });
                    },
                    onTap: item.onTap,
                    icon: item.icon,
                    format: item.format,
                    api: item.api ?? (_, __, ___, ____) {},
                    itemSelect: item.itemSelect ?? (dynamic content, int index, bool selected) {},
                    showSearch: item.showSearch ?? true,
                    selectLabel: item.selectLabel ?? () {},
                    selectValue: item.selectValue ?? () {},
                    items: item.items,
                  )
                : Container();
            break;
          case EFormItemType.selectMultiple:
            child = item.show
                ? WSelectMultiple<T>(
                    key: listKey[item.name],
                    controller: listController[item.name] ?? TextEditingController(),
                    name: item.name,
                    label: item.label,
                    hintText: item.hintText,
                    subtitle: item.subtitle,
                    value: item.value,
                    code: state.value[item.name].length > 0 ? state.value[item.name] : [],
                    space: index != state.list.length - 1,
                    maxLines: item.maxLines,
                    stackedLabel: item.stackedLabel,
                    required: item.required,
                    enabled: item.enabled,
                    onChanged: (value) {
                      _tChange.cancel();
                      if (item.onChange != null) _tChange = Timer(Duration(milliseconds: listTrickMap.isNotEmpty ? 1200 : 0), () { item.onChange!(value, listController); });
                      cubit.saved(value: value, name: item.name);
                      _t.cancel();
                      if (widget.listKeyChanged.contains(item.name)) _t = Timer(const Duration(milliseconds: 1), () { onChangedController(); });
                    },
                    icon: item.icon,
                    format: item.format,
                    api: item.api ?? (_, __, ___, ____) {},
                    itemSelect: item.itemSelect ?? (dynamic content, int index, bool selected) {},
                    showSearch: item.showSearch ?? true,
                    selectLabel: item.selectLabel ?? () {},
                    selectValue: item.selectValue ?? () {},
                    items: item.items,
                  )
                : Container();
            break;
          case EFormItemType.date:
            child = item.show
                ? WDate<T>(
                    key: listKey[item.name],
                    name: item.name,
                    selectDateType: item.selectDateType,
                    controller: listController[item.name] ?? TextEditingController(),
                    label: item.label,
                    hintText: item.hintText,
                    value: item.mode == DateRangePickerSelectionMode.single
                        ? (state.value[item.name] ?? '')
                        : (state.value[item.name] != null && state.value[item.name] != ''
                            ? state.value[item.name].join('|')
                            : ''),
                    subtitle: item.subtitle,
                    space: index != state.list.length - 1,
                    stackedLabel: item.stackedLabel,
                    maxLines: item.maxLines,
                    required: item.required,
                    enabled: item.enabled,
                    onChanged: (value) {
                      dynamic val = value;
                      if (value.contains('|')) val = value.split('|');
                      cubit.saved(value: val, name: item.name);
                      _tChange.cancel();
                      if (item.onChange != null) _tChange = Timer(Duration(milliseconds: listTrickMap.isNotEmpty ? 1200 : 0), () { item.onChange!(val, listController); });
                    },
                    icon: item.icon,
                    mode: item.mode,
                    showTime: item.showTime,
                    view: item.view,
                    readOnly: item.readOnly,
                  )
                : Container();
            break;
          case EFormItemType.time:
            child = item.show
                ? WTime<T>(
                    key: listKey[item.name],
                    controller: listController[item.name] ?? TextEditingController(),
                    label: item.label,
                    hintText: item.hintText,
                    value: state.value[item.name] ?? '',
                    subtitle: item.subtitle,
                    space: index != state.list.length - 1,
                    maxLines: item.maxLines,
                    required: item.required,
                    enabled: item.enabled,
                    onChanged: (value) {
                      _tChange.cancel();
                      if (item.onChange != null) _tChange = Timer(Duration(milliseconds: listTrickMap.isNotEmpty ? 1200 : 0), () { item.onChange!(value, listController); });
                      cubit.saved(value: value, name: item.name);
                    },
                    icon: item.icon,
                  )
                : Container();
            break;
          default:
            if (item.child != null) {
              child = item.show
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.label != '')
                    Container(
                      margin: const EdgeInsets.only(bottom: CSpace.base),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: item.label,
                            style: TextStyle(
                              color: CColor.black,
                              fontSize: CFontSize.lg,
                              fontWeight: FontWeight.w600,
                              height: 22 / CFontSize.base,
                            )),
                      ),
                    ),
                  item.child!,
                  SizedBox(height: index != state.list.length - 1 ? CSpace.xl : 0),
                ],
              ): Container();
            } else {
              child = item.show
                  ? WInput<T>(
                      key: listKey[item.name],
                      controller: listController[item.name] ?? TextEditingController(),
                      label: item.label,
                      hintText: item.hintText,
                      name: item.name,
                      value: state.value[item.name]?.toString() ?? '',
                      subtitle: item.subtitle,
                      space: index != state.list.length - 1,
                      formatNumberType: item.formatNumberType,
                      maxLines: item.maxLines,
                      maxLength: item.maxLength,
                      minLength: item.minLength,
                      maxQuantity: item.maxQuantity,
                      required: item.required,
                      enabled: item.enabled,
                      password: item.password,
                      keyBoard: item.keyBoard,
                      onChanged: (value) {
                        _tChange.cancel();
                        if (item.onChange != null) _tChange = Timer(Duration(milliseconds: listTrickMap.isNotEmpty ? 1200 : 0), () { item.onChange!(value, listController); });
                        cubit.saved(value: value, name: item.name);
                        _t.cancel();
                        if (widget.listKeyChanged.contains(item.name)) _t = Timer(Duration(milliseconds: listTrickMap.isNotEmpty ? 1200 : 0), () { onChangedController(); });
                      },
                      onTap: item.onTap,
                      onValidated: (String value) {
                        if (item.onValidator != null) return item.onValidator!(value, listController);
                        return null;
                      },
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
                children: <Widget>[...items.entries.map((e) => e.value)],
              ));
    });
  }
}
