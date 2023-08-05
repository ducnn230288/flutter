import 'package:flutter/material.dart';

class CPref {
  static String token = 'token';
  static String user = 'user';
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
      case 'ACCEPTED':
        return 'Đang thực hiện';
      case 'ASSIGNED':
        return 'Đã lấy đơn';
      case 'COMPLETED':
        return 'Hoàn thành';
      case 'UN_CONFIRM':
        return 'Chưa xác nhận';
      case 'CONFIRMED':
        return 'Đã xác nhận';
      case 'USER_TRANSFER_CONFIRMED':
        return 'Xác nhận CK';
      case 'RECEIVED_CONFIRMED':
        return 'Đã về tài khoản';
      case 'CANCELED':
        return 'Đã hủy';
      case 'KT':
        return 'Kế toán';
      case 'ORDERER':
        return 'Order Side';
      case 'FARMER':
        return 'Farmer Side';
      case 'MALE':
        return 'Nam';
      case 'FEMALE':
        return 'Nữ';
    }
    return status;
  }
}
