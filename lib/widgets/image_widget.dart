import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '/constants/index.dart';

Widget imageNetwork({
  required String? url,
  BoxFit fit = BoxFit.cover,
  Widget? placeHolder,
  double? width,
  double? height,
}) {
  Widget child = SizedBox(
    width: width,
    height: height,
    child: placeHolder ?? CIcon.placeholderImage,
  );

  if (!(url?.isEmpty ?? true)) {
    child = ExtendedImage.network(
      url!,
      fit: fit,
      width: width,
      height: height,
    );
  }

  return child;
}
