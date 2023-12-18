import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';

class WidgetFilter<T> extends StatefulWidget {
  final List<MFilter> filter;
  final String keyValue;
  final Function(Map<String, dynamic> value, int page, int size, Map<String, dynamic> sort) api;
  final Function(dynamic) format;
  final List<String>? keyForReset;

  const WidgetFilter({
    Key? key,
    required this.filter,
    this.keyValue = '',
    required this.api,
    this.keyForReset,
    required this.format,
  }) : super(key: key);

  @override
  State<WidgetFilter> createState() => _WidgetFilterState<T>();
}

class _WidgetFilterState<T> extends State<WidgetFilter> {
  bool _first = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlocC<T>, BlocS<T>>(
      builder: (context, state) {
        return Container(
          height: 26,
          alignment: Alignment.center,
          child: ListView.separated(
            itemCount: widget.filter.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (_, index) => const HSpacer(CSpace.small),
            itemBuilder: (_, index) {
              final MFilter filter = widget.filter[index];

              if (filter.child != null) return filter.child!;

              final String keyValue = filter.keyValue ?? widget.keyValue;

              bool selected = (filter.onTap != null && state.value[filter.keyValue] != null) ||
                  state.value[keyValue] == filter.value;
              if (index == 0 && state.value.isEmpty) {
                selected = true;
              } else if (_first) {
                bool multiple = false;
                for (int i = 0; i < widget.filter.length; i++) {
                  if (widget.filter[i].child != null) {
                    multiple = true;
                    break;
                  }
                }
                if (multiple ? index == 0 && (state.value.isEmpty && state.value['value'] == null) : index == 0) {
                  selected = true;
                } else {
                  selected = false;
                }
              }
              if (state.value[keyValue] is Map && state.value[keyValue]?['label'] == null && index != 0) {
                selected = false;
              }
              final String label = filter.changeLabel && state.value[keyValue]?['label'] != null
                  ? (state.value[keyValue]?['label'] ?? '')
                  : filter.label;

              return InkWell(
                splashColor: CColor.primary.shade100,
                onTap: () async {
                  _first = index == 0;
                  if (filter.onTap != null) {
                    filter.onTap!();
                  } else {
                    UDialog().startLoading();
                    final cubit = context.read<BlocC<T>>();
                    cubit.saved(name: keyValue, value: filter.value);
                    await cubit.setPage(page: 1, api: widget.api, format: widget.format);
                    UDialog().stopLoading();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: selected ? CColor.primary.shade100 : CColor.black.shade100.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: CSpace.mediumSmall),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (filter.icon != null)
                        Container(
                          margin: const EdgeInsets.only(right: CSpace.small),
                          child: Icon(filter.icon, color: CColor.primary, size: CFontSize.callOut),
                        ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: CSpace.small),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: CFontSize.caption2,
                            fontWeight: selected ? FontWeight.w600 : null,
                            fontFamily: 'SFTextPro',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
