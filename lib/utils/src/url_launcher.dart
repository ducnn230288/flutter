import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
      forceAndroidLocationManager: true,
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
