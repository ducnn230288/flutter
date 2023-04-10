import 'package:flutter/material.dart';

import '/constants/index.dart';

line({double height = 0.5, double? width, Color? color, EdgeInsets? margin}) {
  return Container(
    height: height,
    width: width,
    margin: margin,
    color: color ?? CColor.black.shade200,
  );
}
