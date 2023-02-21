import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class Utils {
  static bool _drawerIsOpened = false;
  static DateTime _lastTimeBackButtonWasClicked = DateTime.now();

  static Future<bool> exitApp(BuildContext context) async {
    if (_drawerIsOpened) {
      Navigator.pop(context);
      return false;
    }
    if (DateTime.now().difference(_lastTimeBackButtonWasClicked) >= const Duration(seconds: 2)) {
      _lastTimeBackButtonWasClicked = DateTime.now();
      Flushbar(
        backgroundColor: Colors.black,
        animationDuration: const Duration(milliseconds: 300),
        messageText: const Center(
          child: Text('Bấm lần nữa để thoát', style: TextStyle(color: Colors.white, fontSize: 10)),
        ),
        duration: const Duration(seconds: 2),
        flushbarPosition: FlushbarPosition.BOTTOM,
        maxWidth: 110,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        borderRadius: BorderRadius.circular(5),
        dismissDirection: FlushbarDismissDirection.VERTICAL,
      ).show(context);
      return false;
    } else {
      return true;
    }
  }
}
