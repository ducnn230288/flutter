import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/utils/index.dart';

class WSelect<T> extends StatefulWidget {
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
  final Function(dynamic content, int index, bool selected) itemSelect;
  final bool showSearch;
  final Function selectLabel;
  final Function selectValue;
  final TextEditingController controller;
  final List? items;
  final Widget? suffix;
  final Function(dynamic)? onTap;
  final double? height;
  final double? width;

  const WSelect({
    super.key,
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
    this.height,
    this.width,
  });

  @override
  State<WSelect> createState() => _WSelectState<T>();
}

class _WSelectState<T> extends State<WSelect> {
  FocusNode focusNode = FocusNode();
  int count = 0;

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
                      if (widget.label != '' || widget.hintText != null)
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: CSpace.sm),
                          child: Text(
                            widget.hintText ?? (widget.label != '' ? widget.label : ''),
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
                          child: WInput(
                            hintText: 'widgets.form.select.Search'.tr(),
                            required: false,
                            icon: 'assets/svgs/search.svg',
                            value: context.read<BlocC>().state.value['fullTextSearch'] ?? '',
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
                          ),
                        ),
                      Expanded(
                        child: WList<dynamic>(
                            items: widget.items,
                            item: (item, int index) {
                              final code = widget.items == null ? widget.selectValue(item) : item.value;
                              final selected = value[widget.name] != null &&
                                  value[widget.name].toString().toLowerCase() ==
                                      code.toString().toLowerCase();

                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: CSpace.base),
                                padding: const EdgeInsets.symmetric(horizontal: CSpace.base),
                                color: selected ? CColor.primary : Colors.transparent,
                                child: widget.items == null
                                    ? widget.itemSelect(item, index, selected)
                                    : itemList(title: Text(item.label, style: TextStyle(fontSize: CFontSize.sm, color: selected ? Colors.white : Colors.black)))
                              );
                            },
                            format: widget.format,
                            onTap: (item) async {
                              widget.controller.text = widget.items == null ? widget.selectLabel(item) : item.label;
                              widget.onChanged(widget.items == null ? widget.selectValue(item) : item.value);
                              await UDialog().delay();
                              if (context.mounted) Navigator.of(context).pop();
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
