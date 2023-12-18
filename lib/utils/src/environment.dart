import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get fileName {
    if (kReleaseMode) {
      return '.env.production';
    }
    return '.env.development';
  }

  static String get apiUrl {
    return dotenv.env['API_URL'] ?? 'API_URL not found!';
  }

  static String get fileUrl {
    return dotenv.env['FILE_URL'] ?? 'FILE_URL not found!';
  }

  static String get uploadUrl {
    return dotenv.env['UPLOAD_URL'] ?? 'UPLOAD_URL not found!';
  }

  static String get appPackage {
    return dotenv.env['APP_PACKAGE'] ?? 'APP_PACKAGE not found!';
  }
}
