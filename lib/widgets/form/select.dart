import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/constants/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/widgets/index.dart';

class WidgetSelect extends StatelessWidget {
  final String label;
  final String value;
  final bool space;
  final int maxLines;
  final bool required;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final String? icon;
  final Function format;
  final Function api;
  final Function itemSelect;
  final bool showSearch;
  final Function selectLabel;
  final Function selectValue;
  final TextEditingController controller;
  final List? items;

  const WidgetSelect({
    Key? key,
    this.label = '',
    this.value = '',
    required this.onChanged,
    this.required = false,
    this.enabled = true,
    this.space = false,
    this.maxLines = 1,
    this.icon,
    required this.format,
    required this.api,
    required this.itemSelect,
    this.showSearch = true,
    required this.selectLabel,
    required this.selectValue,
    required this.controller,
    this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetInput(
      controller: controller,
      label: label,
      value: value,
      space: space,
      maxLines: maxLines,
      required: required,
      enabled: enabled,
      icon: icon,
      suffix: AppIcons.arrowDown,
      onTap: () {
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            AppAuthCubit auth = context.read<AppAuthCubit>();
            return BlocProvider(
              create: (context) => AppFormCubit(),
              child: AlertDialog(
                content: SizedBox(
                  width: 250,
                  child: WidgetList(
                      isPage: false,
                      extendItem: items == null && showSearch ? 1.3 : 0,
                      items: items,
                      top: (items == null && showSearch)
                          ? Column(
                              children: [
                                const SizedBox(
                                  height: Space.large / 2,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: Space.large),
                                  child: BlocBuilder<AppFormCubit, AppFormState>(
                                    builder: (context, state) {
                                      Timer t = Timer(const Duration(seconds: 1), () {});
                                      return Row(
                                        children: [
                                          Flexible(
                                            child: WidgetInput(
                                              label: 'Search',
                                              required: true,
                                              icon: 'assets/svgs/search.svg',
                                              onChanged: (value) async {
                                                context
                                                    .read<AppFormCubit>()
                                                    .saved(name: 'fullTextSearch', value: value);
                                                t.cancel();
                                                t = Timer(const Duration(seconds: 1), () {
                                                  context.read<AppFormCubit>().submit(
                                                      context: context,
                                                      auth: auth,
                                                      api: api,
                                                      getData: true,
                                                      format: format);
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      loadMore: items == null && showSearch,
                      item: items == null
                          ? itemSelect
                          : (ModelFormItem item, Function onTap) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: Space.large),
                              child: itemList(
                                title: Text(item.label, style: const TextStyle(fontSize: FontSizes.paragraph1)),
                                onTap: () => onTap(),
                              )),
                      format: items == null ? format : ModelFormItem.fromJson,
                      onTap: (item) {
                        onChanged(items == null ? selectValue(item) : item.value);
                        controller.text = items == null ? selectLabel(item) : item.label;
                        Navigator.of(context).pop();
                        FocusScope.of(context).unfocus();
                      },
                      api: api),
                ),
                contentPadding: const EdgeInsets.only(top: Space.small),
                actionsPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: Space.large),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Huỷ bỏ'),
                    onPressed: () {
                      controller.clear();
                      Navigator.of(context).pop();
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
