*** Settings ***
Resource                ../keywords/common.robot
Test Setup              Setup
Test Teardown           Tear Down

*** Test Cases ***
DN-01 Verify that Đăng nhập successfully with valid Email and Mật khẩu
  [Tags]                @smoketest               @regression
  When Click "Bỏ qua" button
  When Click "Bắt đầu" button
  When Click "Đăng ký" button
  When Enter "email" in "Địa chỉ Email" with "_RANDOM_"
  When Enter "text" in "Mật khẩu" with "_RANDOM_"
  When Enter "text" in "Nhập lại mật khẩu" with "_@Mật khẩu@_"
  When Click select "Loại tài khoản" with "Order Side"
  When Enter "test name" in "Họ và tên" with "_RANDOM_"
  When Click select "Giới tính" with "Nam"
  When Enter "phone" in "Số điện thoại" with "_RANDOM_"
  When Click "Đăng ký" button


