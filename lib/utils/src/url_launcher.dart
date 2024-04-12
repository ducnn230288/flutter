import 'package:fl_location/fl_location.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/src/routes.dart';
import 'dialogs.dart';

class UrlLauncher {
  static Future<void> launchInBrowser(String url, {Map<String, String>? headers}) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        webViewConfiguration: WebViewConfiguration(
          headers: headers ?? {},
        ),
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> launchInWebViewOrVC(String url, {Map<String, String>? headers}) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        webViewConfiguration: WebViewConfiguration(
          headers: headers ?? {},
        ),
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> launchInWebViewWithJavaScript(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: true,
        ),
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> launchInWebViewWithDomStorage(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        webViewConfiguration: const WebViewConfiguration(
          enableDomStorage: true,
        ),
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    var phone = "tel:$phoneNumber";

    final Uri uri = Uri(
      scheme: 'tel',
      path: phone,
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $phone';
    }
  }
  Future<bool> checkAndRequestPermissionContacts() async {
    var contactsPermission = await Permission.contacts.status;
    if (contactsPermission == PermissionStatus.permanentlyDenied) {
      return false;
    } else if (contactsPermission == PermissionStatus.denied) {
      bool check = false;
      await UDialog().showConfirm(
        title: 'Cần có danh bạ của bạn',
        text: "Khi bật dịch vụ danh bạ, bạn có thể lấy được danh sách danh bạ điện thoai hiện tại của mình ngay lập tức, từ đó bạn đó có thể lấy nhanh thông tin tên và số điện thoại từ danh bạ của mình ra.",
        btnOkText: 'Bật danh bạ',
        btnCancelText: 'Khi khác',
        btnOkOnPress: () async {
          rootNavigatorKey.currentState!.context.pop();
          check = true;
        },
      );
      if (check) return await FlutterContacts.requestPermission(readonly: true);
      return check;
    }
    return true;
  }
  Future<bool> checkAndRequestPermission({bool? background}) async {
    if (!await FlLocation.isLocationServicesEnabled) return false;
    var locationPermission = await FlLocation.checkLocationPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      return false;
    } else if (locationPermission == LocationPermission.denied) {
      bool check = false;
      await UDialog().showConfirm(
        title: 'Cần có vị trí của bạn',
        text: "Khi bật dịch vụ định vị, bạn có thể lấy được vị trí hiện tại của mình ngay lập tức, từ đó chỉ đường từ vị trí hiện tại của mình tới vị trí mục tiêu.",
        btnOkText: 'Bật vị trí',
        btnCancelText: 'Khi khác',
        btnOkOnPress: () async {
          rootNavigatorKey.currentState!.context.pop();
          check = true;
        },
      );
      if (check) {
        locationPermission = await FlLocation.requestLocationPermission();
        if (locationPermission == LocationPermission.denied || locationPermission == LocationPermission.deniedForever) check = false;
      }
      return check;
    }
    if (background == true && locationPermission == LocationPermission.whileInUse) return false;
    return true;
  }

  Future<Location> determinePosition() => FlLocation.getLocation(timeLimit: const Duration(seconds: 10));
}
