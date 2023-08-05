import 'package:flutter/material.dart';

import '/constants/index.dart';

status(
  String status, {
  double? height,
  double? width,
  double? borderRadius,
  double fontSize = 10,
  EdgeInsets? margin,
  EdgeInsets? padding,
  Color? textColor,
  Color? statusColor,
  FontWeight? fontWeight,
}) {
  final Color color = statusColor ?? CColor.statusColor(status);
  final String convertStatus = CPref.statusTitle(status);
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        margin: margin,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: CSpace.small + 1, vertical: CSpace.superSmall / 2),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
        ),
        child: Text(
          convertStatus,
          style: CStyle.caption(
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: CFontSize.caption2,
              fontWeight: fontWeight,
            ),
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}
