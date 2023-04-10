import 'package:flutter/material.dart';

class CPref {
  static String token = 'token';
  static PageStorageBucket bucket = PageStorageBucket();

  static String statusTitle(String status) {
    switch (status) {
      case 'DRAFT':
        return 'Nháp';
      case 'PUBLISHED':
        return 'Đã duyệt';
      case 'ADMIN_REJECTED':
      case 'REJECTED':
      case 'ADMIN_REJECT':
        return 'Từ chối';
      case 'END':
        return 'Kết thúc';
      case 'USED':
        return 'Đã sử dụng';
      case 'UN_USED':
        return 'Chưa sử dụng';
      case 'WAIT_CONFIRM':
      case 'WFA':
        return 'Chờ duyệt';
      case 'APPROVED':
        return 'Đã duyệt';
      case 'CLOSED':
        return 'Đã đóng';
      case 'LOCKED':
        return 'Đã khóa';
      case 'ACTIVE':
        return 'Hoạt động';
      case 'REJECT':
        return 'Từ chối';
      case 'RECEIVE':
    }
    return status;
  }
}
