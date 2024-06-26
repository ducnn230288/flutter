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
  fontSize = CFontSize.sm,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: CSpace.sm),
    child: Row(
      children: [
        Expanded(child: Text(label, style: TextStyle(color: CColor.black.shade300, fontSize: fontSize))),
        SizedBox(
          width: width,
          height: CHeight.sm,
          child: ElevatedButton(
            style: CStyle.buttonFill(backgroundColor: color),
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: CFontSize.base),
                const HSpacer(CSpace.sm),
                Text(title, style: TextStyle(fontSize: fontSize),)
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
