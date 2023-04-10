import 'package:flutter/foundation.dart';

class AppConsole {
  static void dump(dynamic object, {bool line = true, String name = ""}) {
    if (!kReleaseMode) {
      if (object is List) {
        for (var element in object) {
          if (line) {
            log("<--------------------|");
          }

          if (name != "") {
            log("$name: $element");
          } else {
            log(element);
          }

          if (line) {
            log("|-------------------->");
          }
        }
      } else {
        if (line) {
          log("<--------------------|");
        }

        if (name != "") {
          log("$name: $object");
        } else {
          log(object);
        }

        if (line) {
          log("|-------------------->");
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

  static void log(Object? object) {
    if (kDebugMode) {
      print(object);
    }
  }
}
