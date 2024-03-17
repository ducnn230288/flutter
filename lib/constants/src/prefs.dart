import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CPref {
  static String token = 'token';
  static String user = 'user';
  static PageStorageBucket bucket = PageStorageBucket();

  static String statusTitle(String status) {
    switch (status) {
      case 'ALL':
        return 'CPref.ALL'.tr();
      case 'ADMIN':
        return 'CPref.ADMIN'.tr();
      case 'REJECTED':
        return 'CPref.REJECTED'.tr();
      case 'WFA':
        return 'CPref.WFA'.tr();
      case 'APPROVED':
        return 'CPref.APPROVED'.tr();
      case 'COMPLETED':
        return 'CPref.COMPLETED'.tr();
      case 'WAIT_TRANSFER':
        return 'CPref.WAIT_TRANSFER'.tr();
      case 'TRANSFER_CONFIRMED':
        return 'CPref.TRANSFER_CONFIRMED'.tr();
      case 'UN_CONFIRM':
        return 'CPref.UN_CONFIRM'.tr();
      case 'CANCELED':
        return 'CPref.CANCELED'.tr();
      case 'MALE':
        return 'CPref.MALE'.tr();
      case 'FEMALE':
        return 'CPref.FEMALE'.tr();
      case 'DRAFT':
        return 'CPref.DRAFT'.tr();
      case 'WAIT_CONFIRM':
        return 'CPref.WAIT_CONFIRM'.tr();
    }
    return status;
  }
}
