import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/constants/index.dart';
import '/cubit/index.dart';

totalElementTitle<T>({
  String title = 'Tổng cộng',
  int? totalElements,
  required String suffix,
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.end,
  MainAxisSize mainAxisSize = MainAxisSize.max,
  TextStyle? textStyle,
}) =>
    Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Text(
          '$title: ',
          style: TextStyle(
                  fontSize: CFontSize.caption2, color: CColor.black.shade400)
              .merge(textStyle),
        ),
        BlocBuilder<BlocC<T>, BlocS<T>>(
          builder: (context, state) {
            if (state.data.totalElements == null && totalElements == null) {
              return Container(
                height: 11,
                width: 11,
                margin: const EdgeInsets.only(right: 3),
                child: const CircularProgressIndicator(strokeWidth: 1),
              );
            }
            return Text(
              (totalElements != null
                      ? totalElements.toString().padLeft(2, '0')
                      : state.data.totalElements == null
                          ? ''
                          : state.data.totalElements.toString())
                  .padLeft(2, '0'),
              style: TextStyle(
                  fontSize: textStyle?.fontSize ?? CFontSize.caption2,
                  fontWeight: FontWeight.w600),
            );
          },
        ),
        Text(
          ' $suffix',
          style: TextStyle(
                  fontSize: CFontSize.caption2, color: CColor.black.shade400)
              .merge(textStyle),
        ),
      ],
    );
