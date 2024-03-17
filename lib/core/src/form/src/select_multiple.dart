import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/utils/index.dart';

class WSelectMultiple<T> extends StatefulWidget {
  final String name;
  final String label;
  final String? hintText;
  final String? subtitle;
  final List? value;
  final List? code;
  final bool space;
  final int maxLines;
  final bool required;
  final bool enabled;
  final bool stackedLabel;
  final ValueChanged<List> onChanged;
  final String? icon;
  final Function(dynamic json)? format;
  final Function(Map<String, dynamic> value, int page, int size, Map<String, dynamic> sort) api;
  final Function(dynamic content, int index, bool selected) itemSelect;
  final bool showSearch;
  final Function selectLabel;
  final Function selectValue;
  final TextEditingController controller;
  final List? items;
  final double? height;
  final double? width;

  const WSelectMultiple({
    super.key,
    this.label = '',
    this.value,
    this.subtitle,
    required this.onChanged,
    this.required = false,
    this.enabled = true,
    this.space = false,
    this.maxLines = 1,
    this.icon,
    this.format,
    required this.api,
    required this.itemSelect,
    this.showSearch = true,
    this.stackedLabel = true,
    required this.selectLabel,
    required this.selectValue,
    required this.controller,
    this.items,
    this.name = '',
    this.code,
    this.hintText,
    this.height,
    this.width,
  });

  @override
  State<WSelectMultiple> createState() => _WSelectMultipleState<T>();
}

class _WSelectMultipleState<T> extends State<WSelectMultiple> {
  @override
  Widget build(BuildContext context) {
    final value = context.read<BlocC<T>>().state.value;
    return WInput<T>(
      height: widget.height,
      width: widget.width,
      controller: widget.controller,
      label: widget.label,
      hintText: widget.hintText ?? 'widgets.form.input.Choose'.tr(args: [widget.label.toLowerCase()]),
      rulesRequired: 'widgets.form.select.rulesRequired'.tr(),
      space: widget.space,
      maxLines: widget.maxLines,
      required: widget.required,
      stackedLabel: widget.stackedLabel,
      enabled: widget.enabled,
      icon: widget.icon,
      suffix: CIcon.arrowDown,
      focus: true,
      focusNode: focusNode,
      onTap: (_) {
        focusNode.unfocus();
        return showModalBottomSheet<void>(
          context: context,
          builder: (_) {
            return BlocProvider(
              create: (context) => BlocC(),
              child: Builder(
                builder: (context) {
                  return SafeArea(
                    child: Column(
                      children: [
                        if (widget.label != '')
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: CSpace.sm),
                            child: Text(
                              widget.label,
                              style: TextStyle(
                                color: CColor.black.shade700,
                                fontSize: CFontSize.lg,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        if (widget.items == null && widget.showSearch)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: CSpace.sm),
                            child: Builder(
                              builder: (context) {
                                return WInput(
                                  name: 'fullTextSearch',
                                  hintText: 'widgets.form.select.Search'.tr(),
                                  required: false,
                                  icon: 'assets/svgs/search.svg',
                                  onChanged: (value) {
                                    context.read<BlocC>().saved(name: 'fullTextSearch', value: value);
                                    Delay().run(() {
                                      context.read<BlocC>().submit(
                                            showDialog: false,
                                            api: widget.api,
                                            getData: true,
                                            format: widget.format,
                                          );
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              return WList<dynamic>(
                                  items: widget.items,
                                  item: (item, int index) {
                                    final code = widget.items == null ? widget.selectValue(item) : item.value;
                                    final selected = value[widget.name].length > 0 && value[widget.name].map((i) => (widget.selectValue(widget.format!(i))).toString().toLowerCase()).contains(code.toString().toLowerCase());
                                    return Container(
                                        margin: const EdgeInsets.symmetric(horizontal: CSpace.lg),
                                        color: selected ? CColor.primary : Colors.transparent,
                                        child: widget.items == null
                                            ? widget.itemSelect(item, index, selected)
                                            : itemList(title: Text(item.label, style: TextStyle(fontSize: CFontSize.sm, color: selected ? Colors.white : Colors.black,)))
                                    );
                                  },
                                  format: widget.format,
                                  onTapMultiple: (item, BuildContext context) async {
                                    final cubit = context.read<BlocC>();
                                    final newItemValue = widget.items == null ? widget.selectValue(item) : item.value;
                                    if (value[widget.name].length == 0) value[widget.name] = [];
                                    if (listValue.contains(newItemValue)) {
                                      if (widget.required && listValue.length == 1) {
                                        UDialog().showError(title: 'Thông báo!', text: 'Vui lòng chọn tối thiếu 1 lựa chọn');
                                        return;
                                      }
                                      value[widget.name].removeAt(listValue.indexWhere((i) => i == newItemValue));
                                      listValue.remove(newItemValue);
                                    } else {
                                      listValue.add(newItemValue);
                                      value[widget.name].add(item.toJson());
                                    }
                                    text = listValue.length > 1 ? 'Đã chọn: ${listValue.length}' : (listValue.isNotEmpty ? widget.selectLabel(widget.format!(value[widget.name][0])) : '');
                                    widget.onChanged(value[widget.name]);
                                    cubit.setList(list: cubit.state.list);
                                  },
                                  api: widget.api);
                            }
                          ),
                        ),
                      ],
                    ),
                  );
                }
              ),
            );
          },
        ).then((value) {
          widget.controller.text = text;
        });
      },
    );
  }

  FocusNode focusNode = FocusNode();
  String text = '';
  List listValue = [];

  @override
  void initState() {
    final value = context.read<BlocC<T>>().state.value;
    listValue = value[widget.name].length > 0 ? value[widget.name].map((i) => widget.selectValue(widget.format!(i))).toList() : [];
    text = listValue.length > 1 ? 'Đã chọn: ${listValue.length}' : (listValue.isNotEmpty ? widget.selectLabel(widget.format!(value[widget.name][0])) : '');
    Timer(const Duration(milliseconds: 50), () { widget.controller.text = text; });
    super.initState();
  }
}
