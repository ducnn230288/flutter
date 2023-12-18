import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

      return SizedBox(
        height: 32,
        width: width,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(CColor.black.shade100.withOpacity(0.2)),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                side: BorderSide(width: selected ? 1 : 0.00001, color: CColor.primary))),
          ),
          onPressed: onPressed,
          child: FittedBox(
            child: Text(
              title,
              style: TextStyle(
                color: selected ? CColor.primary : CColor.black,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      );
    },
  );
}
