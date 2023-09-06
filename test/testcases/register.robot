*** Settings ***
Resource                ../keywords/common.robot
Test Setup              Setup
Test Teardown           Tear Down

*** Keywords ***
Go to register page
  When Click "Bỏ qua" button
  When Click "Bắt đầu" button
  When Click "Đăng ký" button
      
*** Test Cases ***
# Run device
#     Setup

RG-01 Register successfully with valid value
  [Tags]                @smoketest               @regression
  Go to register page
  When Enter "email" in "Địa chỉ Email" with "_RANDOM_"
  When Enter "text" in "Mật khẩu" with "_RANDOM_"
  When Enter "text" in "Nhập lại mật khẩu" with "_@Mật khẩu@_"
  When Click select "Loại tài khoản" with "Order Side"
  When Enter "test name" in "Họ và tên" with "_RANDOM_"
  When Click select "Giới tính" with "Nam"
  When Enter "phone" in "Số điện thoại" with "_RANDOM_"
  When Click "Đăng ký" button
  Then User look message "Đăng kí tài khoản thành công. Vui lòng kiểm tra email để xác thực tài khoản" with title "Thông báo" popup

  
RG-02 Register with email alrealdy used
  [Tags]                @smoketest               @regression
  Go to register page
  When Enter "email" in "Địa chỉ Email" with "admin@gmail.com"
  When Enter "text" in "Mật khẩu" with "_RANDOM_"
  When Enter "text" in "Nhập lại mật khẩu" with "_@Mật khẩu@_"
  When Click select "Loại tài khoản" with "Order Side"
  When Enter "test name" in "Họ và tên" with "_RANDOM_"
  When Click select "Giới tính" with "Nam"
  When Enter "phone" in "Số điện thoại" with "_RANDOM_"
  When Click "Đăng ký" button
  Then User look message "Email _@Địa chỉ Email@_ đã được sử dụng. Vui lòng lựa chọn một email khác." with title "Cảnh báo" popup

RG-03 Register with phone number alrealdy used
  [Tags]                @smoketest               @regression
  Go to register page
  When Enter "email" in "Địa chỉ Email" with "_RANDOM_"
  When Enter "text" in "Mật khẩu" with "_RANDOM_"
  When Enter "text" in "Nhập lại mật khẩu" with "_@Mật khẩu@_"
  When Click select "Loại tài khoản" with "Order Side"
  When Enter "test name" in "Họ và tên" with "_RANDOM_"
  When Click select "Giới tính" with "Nam"
  When Enter "phone" in "Số điện thoại" with "0123456789"
  When Click "Đăng ký" button
  Then User look message "Số điện thoại _@Số điện thoại@_ đã được sử dụng. Vui lòng lựa chọn số khác." with title "Cảnh báo" popup

RG-04 Register with comfirm password inccorect
  [Tags]                @smoketest               @regression
  Go to register page
  When Enter "email" in "Địa chỉ Email" with "_RANDOM_"
  When Enter "text" in "Mật khẩu" with "_RANDOM_"
  When Enter "text" in "Nhập lại mật khẩu" with "123456789a0"
  When Click select "Loại tài khoản" with "Order Side"
  When Enter "test name" in "Họ và tên" with "_RANDOM_"
  When Click select "Giới tính" with "Nam"
  When Enter "phone" in "Số điện thoại" with "_RANDOM_"
  When Click "Đăng ký" button
  Then User look message "Xác nhận mật khẩu không khớp" with title "Cảnh báo" popup
  

RG-05 Register with empty value
  [Tags]                @smoketest               @regression
  Go to register page
  When Scroll to "Nhập lại mật khẩu" element
  When Scroll to "Loại tài khoản" element
  When Scroll to "Họ và tên" element
  When Scroll to "Số điện thoại" element
  When Click "Đăng ký" button
  Then Required message "Họ và tên" displayed under "Vui lòng nhập họ và tên" field
  Then Required message from select option "Giới tính" displayed under "Vui lòng nhập số điện thoại" field
  Then Required message "Số điện thoại" displayed under "Vui lòng nhập số điện thoại" field
  When Scroll to "Họ và tên" element
  When Scroll to "Loại tài khoản" element
  When Scroll to "Nhập lại mật khẩu" element
  Then Required message from select option "Loại tài khoản" displayed under "Vui lòng chọn loại tài khoản" field
  Then Required message "Địa chỉ Email" displayed under "Vui lòng nhập địa chỉ email" field
  Then Required message "Mật khẩu" displayed under "Vui lòng nhập mật khẩu" field
  Then Required message "Nhập lại mật khẩu" displayed under "Vui lòng nhập nhập lại mật khẩu" field
