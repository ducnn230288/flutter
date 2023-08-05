import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/utils/index.dart';

class WSelectMultiple extends StatefulWidget {
  final String name;
  final String label;
  final String? hintText;
  final String? subtitle;
  final String value;
  final String code;
  final bool space;
  final int maxLines;
  final bool required;
  final bool enabled;
  final bool stackedLabel;
  final ValueChanged<String> onChanged;
  final String? icon;
  final Function? format;
  final Function(Map<String, dynamic> value, int page, int size, Map<String, dynamic> sort) api;
  final Function(dynamic content, int index) itemSelect;
  final bool showSearch;
  final Function selectLabel;
  final Function selectValue;
  final TextEditingController controller;
  final List? items;

  const WSelectMultiple({
    Key? key,
    this.label = '',
    this.value = '',
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
    this.code = '',
    this.hintText,
  }) : super(key: key);

  @override
  State<WSelectMultiple> createState() => _WSelectMultipleState();
}

class _WSelectMultipleState extends State<WSelectMultiple> {
  @override
  Widget build(BuildContext context) {
    return WInput(
      controller: widget.controller,
      label: widget.label,
      hintText: widget.hintText ?? 'widgets.form.input.Choose'.tr(args: [widget.label.toLowerCase()]),
      rulesRequired: 'widgets.form.select.rulesRequired'.tr(),
      value: widget.value,
      space: widget.space,
      maxLines: widget.maxLines,
      required: widget.required,
      stackedLabel: widget.stackedLabel,
      enabled: widget.enabled,
      icon: widget.icon,
      suffix: CIcon.arrowDown,
      focus: true,
      focusNode: focusNode,
      onTap: (text) {
        focusNode.unfocus();
        return showModalBottomSheet<void>(
          context: context,
          builder: (_) {
            return BlocProvider(
              create: (context) => BlocC(),
              child: SafeArea(
                child: Column(
                  children: [
                    if (widget.label != '')
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: CSpace.large),
                        child: Text(
                          widget.label,
                          style: TextStyle(
                            color: CColor.black.shade700,
                            fontSize: CFontSize.headline,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    if (widget.items == null && widget.showSearch)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: CSpace.large),
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
                      child: WList<dynamic>(
                          items: widget.items,
                          item: widget.items == null
                              ? (item, int index) {
                                  final value = context.read<BlocC>().state.value;
                                  final code = widget.items == null ? widget.selectValue(item) : item.value;
                                  return Container(
                                    color: value[widget.name] != null && value[widget.name].contains(code)
                                        ? CColor.primary.shade100
                                        : Colors.transparent,
                                    child: widget.itemSelect(item, index),
                                  );
                                }
                              : (item, int index) {
                                  final value = context.read<BlocC>().state.value;
                                  return Container(
                                      color: value[widget.name] != null && value[widget.name].contains(item.value)
                                          ? CColor.primary.shade100
                                          : Colors.transparent,
                                      padding: const EdgeInsets.symmetric(horizontal: CSpace.large),
                                      child: itemList(
                                        title: Text(item.label, style: const TextStyle(fontSize: CFontSize.paragraph1)),
                                      ));
                                },
                          format: widget.format,
                          onTapMultiple: (item, BuildContext context) async {
                            final cubit = context.read<BlocC>();
                            final newItemValue = widget.items == null ? widget.selectValue(item) : item.value;
                            final newItemLabel = widget.items == null ? widget.selectLabel(item) : item.label;
                            if (listCode.contains(newItemValue)) {
                              if (listCode.length == 1) {
                                UDialog().showError(title: 'Thông báo!', text: 'Vui lòng chọn tối thiếu 1 lựa chọn');
                                return;
                              }
                              listCode.remove(newItemValue);
                              listValue.remove(newItemLabel);
                            } else {
                              listCode.add(newItemValue);
                              listValue.add(newItemLabel);
                            }
                            if (listCode.length > 1) {
                              text = 'Đã chọn: ${listCode.length}';
                            } else if (listCode.isNotEmpty) {
                              text = listValue[0];
                            }
                            cubit.setList(list: cubit.state.list);
                            widget.onChanged(listCode.join(','));
                          },
                          api: widget.api),
                    ),
                  ],
                ),
              ),
            );
          },
        ).then((value) {
          widget.controller.text = text;
          widget.onChanged(listCode.join(','));
        });
      },
    );
  }

  FocusNode focusNode = FocusNode();
  String text = '';
  List listCode = [];
  List listValue = [];

  @override
  void initState() {
    listCode = widget.code != '' ? widget.code.split(',') : [];
    listValue = widget.value != '' ? widget.value.split(',') : [];
    if (listCode.length > 1) {
      text = 'Đã chọn: ${listCode.length}';
    } else if (listCode.isNotEmpty) {
      text = listValue[0];
    }
    super.initState();
  }
}
