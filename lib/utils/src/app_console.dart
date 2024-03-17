import 'dart:developer';
import 'package:flutter/foundation.dart';

class AppConsole {
  static void dump(dynamic object, {bool line = true, String name = ""}) {
    if (!kReleaseMode) {
      if (object is List) {
        for (var element in object) {
          if (line) {
            printLog("<--------------------|");
          }

          if (name != "") {
            printLog("$name: $element");
          } else {
            printLog(element);
          }

          if (line) {
            printLog("|-------------------->");
          }
        }
      } else {
        if (line) {
          printLog("<--------------------|");
        }

        if (name != "") {
          printLog("$name: $object");
        } else {
          printLog(object);
        }

        if (line) {
          printLog("|-------------------->");
        }
      }
    }
  }

  static void dumpInitState(dynamic runtimeType) {
    AppConsole.dump("--------- initState:$runtimeType ---------");
  }

  static void dumpDisposeState(dynamic runtimeType) {
    AppConsole.dump("--------- dispose:$runtimeType ---------");
  }

  static void printLog(Object? object) {
    if (kDebugMode) {
      log(object.toString());
    }
  }
}
