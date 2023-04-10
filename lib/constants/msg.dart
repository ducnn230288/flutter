class Msg {
  Msg._();

  static const Map<String, dynamic> text = {
    //common
    "working_time": "Thời gian làm việc",
    "total_employee": "Số lượng nhân viên",
    "doctor": "Bác sĩ",
    "detail": "Chi tiết",
    "employee": "Nhân viên",
    "total_machine_seats": "Số lượng ghế máy",
    "machine": "Máy",
    "total_working_year": "Số năm kinh nghiệm",
    "year": "Năm",
    "btn_edit": "Chỉnh sửa",
    "btn_delete": "Xoá",
    "title_confirm_before_delete": "Xác nhận trước khi xoá",
    "des_confirm_before_delete": "Thao tác này sẽ làm mất đi dữ liệu của bạn. Bạn có chắc chắn thực hiện?",
    "save_info": "LƯU THÔNG TIN",
    "province": "Tỉnh thành",
    "district": "Huyện/Thành phố",
    "commune": "Phường xã",
    "service_description": "Mô tả dịch vụ",
    "supervisor_name": "Người đứng đầu",
    "supervisor_description": "Mô tả người đứng đầu",

    // Clinic
    "clinic_detail": "Chi tiết phòng khám",
    "clinic_name": "Tên phòng khám",
    "clinic_add_title": "Thêm phòng khám",
    "clinic_edit_title": "Chỉnh sửa phòng khám",
    "clinic_search_title": "Tìm kiếm phòng khám",
    "clinic_list": "Danh sách phòng khám",
    "clinic_supervisor": "Phụ trách phòng khám",
    "clinic_supervisor_degree": "Ảnh bằng cấp",
    "clinic_supervisor_nationalId": "Ảnh CCCD",
    "clinic_license": "Chứng chỉ phòng khám",
    "clinic_equipment": "Ảnh trang thiết bị phòng khám",
    "clinic_address": "Địa chỉ phòng khám",
  };

  static String getMsg(String msgKey, {String df = ''}) {
    if (text.containsKey(msgKey)) {
      return text[msgKey];
    } else {
      return df;
    }
  }
}
