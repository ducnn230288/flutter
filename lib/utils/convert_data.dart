import 'package:easy_localization/easy_localization.dart';

class Convert {
  static String dateTime(String dateTime) {
    if (dateTime == '') return '';
    return DateFormat('HH:mm dd/MM/yyyy').format(DateTime.parse(dateTime));
  }

  static String dateTimeAgo(String dateTime) {
    if (dateTime == '') return '';
    final DateTime now = DateTime.now();
    final int day = now.difference(DateTime.parse(dateTime)).inDays;
    if (day >= 1 && day < 30) {
      return '$day ${'utils.app_console.days ago'.tr()}';
    }
    if (day >= 30) {
      return '${(day / 30).toStringAsFixed(0)} ${'utils.app_console.months ago'.tr()}';
    }
    if (day >= 365) {
      return '${(day / 365).toStringAsFixed(0)} ${'utils.app_console.years ago'.tr()}';
    }
    return DateFormat('HH:mm dd/MM/yyyy').format(DateTime.parse(dateTime));
  }

  static String dateTimeSecond(String dateTime) {
    if (dateTime == '') return '';
    return DateFormat('HH:mm:ss dd/MM/yyyy').format(DateTime.parse(dateTime));
  }

  static String dateLocation(String dateTime) {
    if (dateTime == '') {
      return '';
    }
    return DateFormat('dd MMMM, yyyy', 'vi').format(DateTime.parse(dateTime));
  }

  static String hours(String dateTime) {
    if (dateTime == '') return '';
    return DateFormat('HH:mm').format(DateTime.parse(dateTime));
  }

  static String hoursLocation(String dateTime) {
    if (dateTime == '') return '';
    return DateFormat('HH:mm a').format(DateTime.parse(dateTime));
  }

  static String date(String dateTime) {
    if (dateTime == '') {
      return '';
    }
    return DateFormat('dd/MM/yyyy').format(DateTime.parse(dateTime));
  }

  static String dateChart(String dateTime) {
    if (dateTime == '') {
      return '';
    }
    return DateFormat('dd/MM').format(DateTime.parse(dateTime));
  }

  static String currency(double price, String unit) {
    switch (unit) {
      case 'VND':
        unit = 'VND';
        break;
      case 'UNIT':
        unit = 'VND/m\u00B2';
        break;
      case 'AGREE':
        return 'utils.app_console.Agreement'.tr();
      default:
        unit = 'VND';
    }
    double convertPrice = double.parse(price.toStringAsFixed(0));
    if (convertPrice >= 1000000 && price < 1000000000) {
      convertPrice /= 1000000;
      unit = '${'utils.app_console.million'.tr()} $unit';
      if (double.parse(convertPrice.toStringAsFixed(2)) == 1000) {
        convertPrice = 1;
        unit = '${'utils.app_console.billion'.tr()} $unit';
      }
    }
    if (price >= 1000000000) {
      convertPrice /= 1000000000;
      unit = 'tỷ $unit';
    }
    return '${NumberFormat().format(double.parse(convertPrice.toStringAsFixed(2)))} $unit'.replaceAll(',', '.');
  }

  static String price(double price, [String unit = 'đ']) {
    double convertPrice = double.parse(price.toStringAsFixed(0));
    return '${NumberFormat().format(double.parse(convertPrice.toStringAsFixed(2)))}$unit'.replaceAll(',', '.');
  }

  static String phoneNumber(String number) {
    if (number == '') return '';
    return number.toString().replaceAllMapped(RegExp(r'(\d{4})(\d{3})(\d+)'), (Match m) => "${m[1]} ${m[2]} ${m[3]}");
  }

  static String hidePhoneNumber(String number, int size, [String hide = '*']) {
    if (size == 0) return number;
    String initHide = hide;
    for (int i = 0; i < size - 1; i++) {
      hide = hide + initHide;
    }
    return number.replaceRange(number.length - size, null, hide);
  }

  static String thousands(String number, [String separation = '.']) {
    String priceInText = "";
    int counter = 0;
    for (int i = (number.length - 1); i >= 0; i--) {
      counter++;
      String str = number[i];
      if ((counter % 3) != 0 && i != 0) {
        priceInText = "$str$priceInText";
      } else if (i == 0) {
        priceInText = "$str$priceInText";
      } else {
        priceInText = "$separation$str$priceInText";
      }
    }
    return priceInText.trim();
  }

  static String roleName(role) {
    switch (role) {
      case 'ADMIN':
      case 10:
        return 'utils.app_console.System management'.tr();
    }
    return 'utils.app_console.Undefined'.tr();
  }
}
