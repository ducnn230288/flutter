import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/constants/index.dart';
import '/cubit/index.dart';
import '/widgets/index.dart';

class WSelect extends StatefulWidget {
  final String label;
  final String value;
  final bool space;
  final int maxLines;
  final bool required;
  final bool enabled;
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

  const WSelect({
    Key? key,
    this.label = '',
    this.value = '',
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
    required this.selectLabel,
    required this.selectValue,
    required this.controller,
    this.items,
  }) : super(key: key);

  @override
  State<WSelect> createState() => _WSelectState();
}

class _WSelectState extends State<WSelect> {
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return WInput(
      controller: widget.controller,
      label: widget.label,
      value: widget.value,
      space: widget.space,
      maxLines: widget.maxLines,
      required: widget.required,
      enabled: widget.enabled,
      icon: widget.icon,
      suffix: CIcon.arrowDown,
      focus: true,
      focusNode: focusNode,
      onTap: () {
        focusNode.unfocus();
        return showModalBottomSheet<void>(
          // isDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return BlocProvider(
              create: (context) => BlocC(),
              child: SizedBox(
                width: 250,
                child: WList(
                    isPage: false,
                    extendItem: widget.items == null && widget.showSearch ? 25 : 1,
                    items: widget.items,
                    top: Column(
                      children: [
                        const SizedBox(
                          height: CSpace.large / 2,
                        ),
                        Text(
                          widget.label,
                          style: TextStyle(color: CColor.black.shade400, fontSize: CFontSize.paragraph1),
                        ),
                        const SizedBox(
                          height: CSpace.large / 2,
                        ),
                        (widget.items == null && widget.showSearch)
                            ? Container(
                                padding: const EdgeInsets.symmetric(horizontal: CSpace.large),
                                child: BlocBuilder<BlocC, BlocS>(
                                  builder: (context, state) {
                                    Timer t = Timer(const Duration(seconds: 1), () {});
                                    return Row(
                                      children: [
                                        Flexible(
                                          child: WInput(
                                            label: 'widgets.form.select.Search'.tr(),
                                            required: true,
                                            icon: 'assets/svgs/search.svg',
                                            onChanged: (value) async {
                                              context.read<BlocC>().saved(name: 'fullTextSearch', value: value);
                                              t.cancel();
                                              t = Timer(const Duration(seconds: 1), () {
                                                context
                                                    .read<BlocC>()
                                                    .submit(api: widget.api, getData: true, format: widget.format);
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                    loadMore: widget.items == null && widget.showSearch,
                    item: widget.items == null
                        ? widget.itemSelect
                        : (item, int index) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: CSpace.large),
                            child: itemList(
                              title: Text(item.label, style: const TextStyle(fontSize: CFontSize.paragraph1)),
                            )),
                    format: widget.format,
                    onTap: (item) async {
                      widget.onChanged(widget.items == null ? widget.selectValue(item) : item.value);
                      widget.controller.text = widget.items == null ? widget.selectLabel(item) : item.label;
                      await Future.delayed(const Duration(milliseconds: 50));
                      // focusNode.nextFocus();
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    api: widget.api),
              ),
            );
          },
        );
      },
    );
  }
}
