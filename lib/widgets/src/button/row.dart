import 'package:flutter/material.dart';

import '/constants/index.dart';
import '/core/index.dart';

buttonRow({
  required String label,
  required String title,
  required IconData icon,
  required Function() onPressed,
  required Color color,
  required double width,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: CSpace.small),
    child: Row(
      children: [
        Expanded(child: Text(label, style: TextStyle(color: CColor.black.shade300))),
        SizedBox(
          width: width,
          height: CHeight.superSmall,
          child: ElevatedButton(
            style: CStyle.buttonFill(backgroundColor: color),
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: CFontSize.title3),
                const HSpacer(CSpace.small),
                Text(title)
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
