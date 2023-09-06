import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/utils/index.dart';

class WSelect extends StatefulWidget {
  final String name;
  final String label;
  final String? hintText;
  final String? subtitle;
  final String value;
  final bool space;
  final int maxLines;
  final bool required;
  final bool enabled;
  final bool stackedLabel;
  final ValueChanged<String> onChanged;
  final String? icon;
  final Function(dynamic json)? format;
  final Function(Map<String, dynamic> value, int page, int size, Map<String, dynamic> sort) api;
  final Function(dynamic content, int index) itemSelect;
  final bool showSearch;
  final Function selectLabel;
  final Function selectValue;
  final TextEditingController controller;
  final List? items;
  final Widget? suffix;
  final Function(dynamic)? onTap;

  const WSelect({
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
    this.hintText,
    this.suffix,
    this.onTap,
  }) : super(key: key);

  @override
  State<WSelect> createState() => _WSelectState();
}

class _WSelectState extends State<WSelect> {
  FocusNode focusNode = FocusNode();
  int count = 0;

  @override
  Widget build(BuildContext context) {
    final value = context.read<BlocC>().state.value;
    return WInput(
      controller: widget.controller,
      label: widget.label,
      hintText: widget.hintText ?? 'widgets.form.input.Choose'.tr(args: [widget.label.toLowerCase()]),
      rulesRequired: 'widgets.form.select.rulesRequired'.tr(),
      value: widget.value,
      space: widget.space,
      maxLines: widget.maxLines,
      required: widget.required,
      enabled: widget.enabled,
      subtitle: widget.subtitle,
      stackedLabel: widget.stackedLabel,
      icon: widget.icon,
      suffix: widget.suffix ?? CIcon.arrowDown,
      focus: true,
      focusNode: focusNode,
      onTap: (text) {
        if (widget.onTap != null) return widget.onTap!(text);
        focusNode.unfocus();
        return showModalBottomSheet<void>(
          context: context,
          builder: (_) {
            return BlocProvider(
              create: (context) => BlocC(),
              child: Builder(builder: (context) {
                while (count == 0) {
                  value.forEach((name, value) {
                    context.read<BlocC>().saved(name: name, value: value);
                  });
                  count++;
                }
                return SafeArea(
                  child: Column(
                    children: [
                      if (widget.label != '')
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: CSpace.small),
                          child: Text(
                            widget.hintText ?? (widget.label != '' ? widget.label : ''),
                            style: TextStyle(
                              color: CColor.black.shade700,
                              fontSize: CFontSize.headline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      if (widget.items == null && widget.showSearch)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: CSpace.small),
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
                                      color: value[widget.name] != null &&
                                              value[widget.name].toString().toLowerCase() ==
                                                  code.toString().toLowerCase()
                                          ? CColor.primary.shade100
                                          : Colors.transparent,
                                      child: widget.itemSelect(item, index),
                                    );
                                  }
                                : (item, int index) {
                                    final value = context.read<BlocC>().state.value;
                                    return Container(
                                        color: value[widget.name] != null &&
                                                value[widget.name].toString().toLowerCase() == item.value.toLowerCase()
                                            ? CColor.primary.shade100
                                            : Colors.transparent,
                                        padding: const EdgeInsets.symmetric(horizontal: CSpace.small),
                                        child: itemList(
                                          title:
                                              Text(item.label, style: const TextStyle(fontSize: CFontSize.paragraph1)),
                                        ));
                                  },
                            format: widget.format,
                            onTap: (item) async {
                              widget.controller.text = widget.items == null ? widget.selectLabel(item) : item.label;
                              widget.onChanged(widget.items == null ? widget.selectValue(item) : item.value);
                              await UDialog().delay();
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            },
                            api: widget.api),
                      ),
                    ],
                  ),
                );
              }),
            );
          },
        );
      },
    );
  }
}
