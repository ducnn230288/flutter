import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uberental/utils/dialogs.dart';

import '/constants/index.dart';
import '/cubit/index.dart';
import '/widgets/index.dart';

class WSelectMultiple extends StatefulWidget {
  final String name;
  final String label;
  final String value;
  final String code;
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

  const WSelectMultiple({
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
    this.name = '',
    this.code = '',
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
          isDismissible: false,
          context: context,
          builder: (_) {
            return WillPopScope(
              onWillPop: () async => false,
              child: BlocProvider(
                create: (_) => BlocC(),
                child: SizedBox(
                  width: 250,
                  child: WList(
                      isPage: false,
                      extendItem: widget.items == null && widget.showSearch ? 25 : 1,
                      items: widget.items,
                      top: Column(
                        children: [
                          const SizedBox(height: CSpace.large / 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: CSpace.large),
                              Text(
                                widget.label,
                                style: TextStyle(color: CColor.black.shade400, fontSize: CFontSize.paragraph1),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: CSpace.large),
                                child: GestureDetector(
                                  onTap: () {
                                    widget.controller.text = text;
                                    widget.onChanged(listCode.join(','));
                                    context.pop();
                                  },
                                  child: Text('Xong', style: TextStyle(color: CColor.primary)),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: CSpace.large / 2),
                          if (widget.items == null && widget.showSearch)
                            Container(
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
                        ],
                      ),
                      loadMore: widget.items == null && widget.showSearch,
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
                          : (item, int index) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: CSpace.large),
                              child: itemList(
                                  title: Text(item.label, style: const TextStyle(fontSize: CFontSize.paragraph1)))),
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
                          text = 'Chọn nhiều...';
                        } else if (listCode.length > 0) {
                          text = listValue[0];
                        }
                        cubit.setList(list: cubit.state.list);
                        widget.onChanged(listCode.join(','));
                      },
                      api: widget.api),
                ),
              ),
            );
          },
        );
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
    super.initState();
  }
}
