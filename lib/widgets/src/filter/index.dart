import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';
import 'button.dart';

class WidgetFilter<T> extends StatefulWidget {
  final List<MFilter> filter;
  final String keyValue;
  final Function(Map<String, dynamic> value, int page, int size, Map<String, dynamic> sort) api;
  final Function(dynamic) format;
  final List<String>? keyForReset;

  const WidgetFilter({
    super.key,
    required this.filter,
    this.keyValue = '',
    required this.api,
    this.keyForReset,
    required this.format,
  });

  @override
  State<WidgetFilter> createState() => _WidgetFilterState<T>();
}

class _WidgetFilterState<T> extends State<WidgetFilter> {
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
            separatorBuilder: (_, index) => const HSpacer(CSpace.sm),
            itemBuilder: (_, index) {
              final MFilter filter = widget.filter[index];

              if (filter.child != null) return filter.child!;

              final String keyValue = filter.keyValue ?? widget.keyValue;

              bool selected = (filter.onTap != null && state.value[filter.keyValue] != null) ||
                  state.value[keyValue] == filter.value;
              if (!selected && index == 0 && (state.value.isEmpty || state.value[keyValue] == '')) {
                selected = true;
              }
              final String label = filter.changeLabel && state.value[keyValue]?['label'] != null
                  ? (state.value[keyValue]?['label'] ?? '')
                  : filter.label;

              return WFilterButton(
                selected: selected,
                onPressed: () async {
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (filter.icon != null)
                      Container(
                        margin: const EdgeInsets.only(right: CSpace.sm),
                        child: Icon(filter.icon, color: CColor.primary, size: CFontSize.base),
                      ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: CSpace.sm),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: CFontSize.xs,
                          fontWeight: selected ? FontWeight.w600 : null,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
