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

dottedLine(
    {double thickness = 1,
    Color? color,
    Axis axis = Axis.horizontal,
    double dashSize = 4,
    double? heightVertical,
    EdgeInsets? margin,
    double? space}) {
  if (axis == Axis.vertical) {
    return Container(
      margin: margin,
      height: heightVertical ?? MediaQuery.of(rootNavigatorKey.currentState!.context).size.width,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxHeight = constraints.constrainHeight();
          final dashCount = (boxHeight / (2 * dashSize)).floor();
          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: axis,
            children: List.generate(dashCount, (_) {
              return Container(width: thickness, height: dashSize, color: color ?? CColor.hintColor);
            }),
          );
        },
      ),
    );
  }
  return Container(
    margin: margin,
    child: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (2 * dashSize)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: axis,
          children: List.generate(dashCount, (_) {
            return Container(width: dashSize, height: thickness, color: color ?? CColor.black.shade200);
          }),
        );
      },
    ),
  );
}
