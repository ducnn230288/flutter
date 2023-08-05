import 'package:flutter/material.dart';

import '/constants/index.dart';
import '/core/index.dart';

class WSeparation extends StatelessWidget {
  final String title;
  final EdgeInsets? padding;

  const WSeparation({Key? key, required this.title, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w400, color: CColor.hintColor)),
          const HSpacer(10),
          Expanded(child: line())
        ],
      ),
    );
  }
}
