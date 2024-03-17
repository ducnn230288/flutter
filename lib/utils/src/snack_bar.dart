import 'package:flutter/material.dart';

import '/constants/index.dart';

class USnackBar {
  USnackBar._();

  static final ScaffoldMessengerState _scaffold = ScaffoldMessenger.of(rootNavigatorKey.currentState!.context);

  static void smallSnackBar({
    required String title,
    bool showLoading = false,
    bool isInfiniteTime = false,
    double width = 160,
    Duration? duration,
  }) {
    _scaffold.showSnackBar(SnackBar(
      content: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showLoading)
              Container(
                height: CFontSize.sm,
                width: CFontSize.sm,
                margin: const EdgeInsets.only(right: CSpace.base),
                child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 1.5),
              ),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: CFontSize.sm)),
          ],
        ),
      ),
      width: width,
      elevation: 0,
      duration: isInfiniteTime ? const Duration(minutes: 1) : duration ?? const Duration(seconds: 2),
      padding: const EdgeInsets.symmetric(vertical: CSpace.base, horizontal: 0),
      behavior: SnackBarBehavior.floating,
      backgroundColor: CColor.black.shade300,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CSpace.sm)),
    ));
  }

  static void hideSnackBar() {
    _scaffold.hideCurrentSnackBar();
  }
}
