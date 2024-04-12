import 'package:flutter/material.dart';

import '/constants/index.dart';

class WFilterButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool selected;

  const WFilterButton({super.key, required this.onPressed,required this.child, this.selected = false });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: CColor.primary.shade100,
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? CColor.primary.shade100 : CColor.black.shade100.withOpacity(0.2),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: CSpace.base),
        child: child
      )
    );
  }
}
