import 'package:flutter/material.dart';

import '/constants/index.dart';
import '/core/index.dart';

class WSeparation extends StatelessWidget {
  final String title;
  final EdgeInsets? padding;

  const WSeparation({super.key, required this.title, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w400, color: CColor.black.shade300)),
          const HSpacer(CSpace.base),
          Expanded(child: line())
        ],
      ),
    );
  }
}
