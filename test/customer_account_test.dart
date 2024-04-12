import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/core/index.dart';
import 'package:flutter_app/widgets/src/filter/button.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'common.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Customer Account', (WidgetTester tester) async {
    await initAppWidgetTest(tester);

    await tapButtonPump(tester, 'Tiếp tục', type: TextButton);
    await tapButtonPump(tester, 'Tiếp tục', type: TextButton);
    await tapButtonPump(tester, 'Bắt đầu', type: TextButton);
    await tester.enterText(find.byKey(const ValueKey("Địa chỉ Email")), 'admin@gmail.com');
    await tester.enterText(find.byKey(const ValueKey("Mật khẩu")), '123123');
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    await tapButtonPump(tester, 'Đăng nhập');
    await pumpUntilFound(tester, find.text("Home"));
    expect(find.text("Home"), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey("drawer_menu")));
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    await tester.tap(find.text('Quản lý tài khoản'));
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    await tester.dragUntilVisible(
      find.text('Tài khoản người dùng'),
      find.byType(SingleChildScrollView),
      const Offset(0, 500),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    await tester.tap(find.text('Tài khoản người dùng'));
    await tester.pumpAndSettle(const Duration(milliseconds: 300));

    expect(find.text('Tài khoản người dùng'), findsOneWidget);
    expect(find.byKey(const ValueKey("Tìm kiếm")), findsOneWidget);
    expect(find.widgetWithText(WFilterButton, "Tất cả"), findsOneWidget);
    expect(find.widgetWithText(WFilterButton, "Order Side"), findsOneWidget);
    expect(find.widgetWithText(WFilterButton, "Farmer Side"), findsOneWidget);
    expect(find.byKey(const ValueKey("back_screen")), findsOneWidget);
    expect(find.byKey(const ValueKey("add")), findsOneWidget);
    expect(find.byKey(const ValueKey("filter")), findsOneWidget);
    expect(find.byKey(const ValueKey("list")), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey("add")));
    await tester.pumpAndSettle(const Duration(milliseconds: 300));

    expect(find.text('Tạo mới tài khoản'), findsOneWidget);
    expect(find.byKey(const ValueKey("Thông tin đăng ký")), findsOneWidget);
    expect(find.byKey(const ValueKey("Email")), findsOneWidget);
    expect(find.byKey(const ValueKey("Mật khẩu")), findsOneWidget);
    expect(find.byKey(const ValueKey("Xác nhận mật khẩu")), findsOneWidget);
    expect(find.byKey(const ValueKey("Loại tài khoản")), findsOneWidget);
    expect(find.byKey(const ValueKey("Thông tin cá nhân")), findsOneWidget);
    expect(find.byKey(const ValueKey("Họ và tên")), findsOneWidget);
    expect(find.byKey(const ValueKey("Giới tính")), findsOneWidget);
    expect(find.byKey(const ValueKey("Số điện thoại")), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Tạo mới"), findsOneWidget);
    expect(find.byKey(const ValueKey("back_screen")), findsOneWidget);
    await tapButtonPump(tester, 'Tạo mới');
    expect(find.descendant(of: find.byKey(const ValueKey("Email")), matching: find.text('Xin vui lòng nhập email')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const ValueKey("Mật khẩu")), matching: find.text('Xin vui lòng nhập mật khẩu')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const ValueKey("Xác nhận mật khẩu")), matching: find.text('Xin vui lòng nhập xác nhận mật khẩu')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const ValueKey("Loại tài khoản")), matching: find.text('Xin vui lòng chọn loại tài khoản')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const ValueKey("Họ và tên")), matching: find.text('Xin vui lòng nhập họ và tên')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const ValueKey("Giới tính")), matching: find.text('Xin vui lòng chọn giới tính')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const ValueKey("Số điện thoại")), matching: find.text('Xin vui lòng nhập số điện thoại')), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey("Email")), faker.person.name());
    await tester.enterText(find.byKey(const ValueKey("Mật khẩu")), faker.internet.password());
    await tester.enterText(find.byKey(const ValueKey("Xác nhận mật khẩu")), faker.internet.password());
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    await tester.dragUntilVisible(
      find.byKey(const ValueKey("Loại tài khoản")),
      find.byType(SingleChildScrollView),
      const Offset(0, 500),
    );
    await tester.tap(find.byKey(const ValueKey("Loại tài khoản")));
    await pumpUntilFound(tester, find.text('Farmer Side'));
    await tester.tap(find.text('Farmer Side'));

    await tester.enterText(find.byKey(const ValueKey("Họ và tên")), faker.person.name());
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    await tester.dragUntilVisible(
      find.byKey(const ValueKey("Giới tính")),
      find.byType(SingleChildScrollView),
      const Offset(0, 500),
    );
    await tester.tap(find.byKey(const ValueKey("Giới tính")));
    await pumpUntilFound(tester, find.text('Nữ'));
    await tester.tap(find.text('Nữ'));
    await tester.enterText(find.byKey(const ValueKey("Số điện thoại")), '035');
    await tapButtonPump(tester, 'Tạo mới');
    expect(find.descendant(of: find.byKey(const ValueKey("Mật khẩu")), matching: find.text('Mật khẩu không khớp')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const ValueKey("Xác nhận mật khẩu")), matching: find.text('Mật khẩu không khớp')), findsOneWidget);

    String password = faker.internet.password();
    await tester.enterText(find.byKey(const ValueKey("Mật khẩu")), password);
    await tester.enterText(find.byKey(const ValueKey("Xác nhận mật khẩu")), password);
    await tapButtonPump(tester, 'Tạo mới');

    await pumpUntilFound(tester, find.text("Email không hợp lệ"));
    await tester.tap(find.widgetWithText(TextButton, "Thoát"));
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    await tester.enterText(find.byKey(const ValueKey("Email")), faker.internet.email());
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
    await tapButtonPump(tester, 'Tạo mới');
    await pumpUntilFound(tester, find.text("Số điện thoại gồm 10 số"));
    await tester.tap(find.widgetWithText(TextButton, "Thoát"));
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    await tester.enterText(find.byKey(const ValueKey("Số điện thoại")), faker.phoneNumber.random.fromPattern(['##########']));
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
    await tapButtonPump(tester, 'Tạo mới');
    await pumpUntilFound(tester, find.text("Tạo tài khoản thành công"));

    await tester.tap(find.widgetWithText(TextButton, "Đồng ý"));
    await tester.pumpAndSettle(const Duration(milliseconds: 300));

    await tester.tap(find.byType(WItem).first);
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    expect(find.byKey(const ValueKey("Thông tin chung")), findsOneWidget);
  });
}
