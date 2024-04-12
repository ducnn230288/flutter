import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../filter/button.dart';
import '/constants/index.dart';
import '/cubit/index.dart';

buttonSelect({
  required String title,
  required double width,
  required String key,
  required dynamic value,
}) {
  return BlocBuilder<BlocC, BlocS>(
    builder: (context, state) {
      final bool selected = state.value[key] == value;
      onPressed() {
        final cubit = context.read<BlocC>();
        if (selected) {
          cubit.removeKey(name: key, isEmit: true);
        } else {
          cubit.addValue(value: value, name: key);
        }
      }

      return WFilterButton(
        onPressed: onPressed,
        selected: selected,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: CSpace.sm),
          child: Text(
            title,
            style: TextStyle(
                fontSize: CFontSize.xs,
                fontWeight: selected ? FontWeight.w600 : null,
            ),
          ),
        ),
      );
    },
  );
}
