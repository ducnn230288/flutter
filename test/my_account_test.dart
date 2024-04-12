import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'common.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('My Account', (WidgetTester tester) async {
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
    await tester.tap(find.text('Tài khoản của tôi'));
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    await tester.dragUntilVisible(
      find.text('Đổi mật khẩu'),
      find.byType(SingleChildScrollView),
      const Offset(0, 500),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    await tester.tap(find.text('Đổi mật khẩu'));
    await tester.pumpAndSettle(const Duration(milliseconds: 300));

    expect(find.text('Đổi mật khẩu'), findsOneWidget);
    expect(find.byKey(const ValueKey("Mật khẩu cũ")), findsOneWidget);
    expect(find.byKey(const ValueKey("Mật khẩu mới")), findsOneWidget);
    expect(find.byKey(const ValueKey("Xác nhận mật khẩu mới")), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Cập nhật"), findsOneWidget);
    expect(find.byKey(const ValueKey("back_screen")), findsOneWidget);

    await tapButtonPump(tester, 'Cập nhật');
    expect(find.descendant(of: find.byKey(const ValueKey("Mật khẩu cũ")), matching: find.text('Xin vui lòng nhập mật khẩu cũ')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const ValueKey("Mật khẩu mới")), matching: find.text('Xin vui lòng nhập mật khẩu mới')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const ValueKey("Xác nhận mật khẩu mới")), matching: find.text('Xin vui lòng nhập xác nhận mật khẩu mới')), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey("Mật khẩu cũ")), faker.internet.password());
    String password = faker.internet.password();
    await tester.enterText(find.byKey(const ValueKey("Mật khẩu mới")), password);
    await tester.enterText(find.byKey(const ValueKey("Xác nhận mật khẩu mới")), password);
    await tapButtonPump(tester, 'Cập nhật');
    await pumpUntilFound(tester, find.text("Mật khẩu cũ không chính xác"));
    await tester.tap(find.widgetWithText(TextButton, "Thoát"));
    await tester.pumpAndSettle(const Duration(milliseconds: 300));

    await tester.enterText(find.byKey(const ValueKey("Mật khẩu cũ")), '123123');
    await tester.enterText(find.byKey(const ValueKey("Mật khẩu mới")), faker.internet.password());
    await tester.enterText(find.byKey(const ValueKey("Xác nhận mật khẩu mới")), faker.internet.password());
    expect(find.descendant(of: find.byKey(const ValueKey("Mật khẩu mới")), matching: find.text('Mật khẩu không khớp')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const ValueKey("Xác nhận mật khẩu mới")), matching: find.text('Mật khẩu không khớp')), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey("Mật khẩu cũ")), '123123');
    await tester.enterText(find.byKey(const ValueKey("Mật khẩu mới")), '123123');
    await tester.enterText(find.byKey(const ValueKey("Xác nhận mật khẩu mới")), '123123');
    await tapButtonPump(tester, 'Cập nhật');
    await pumpUntilFound(tester, find.text("Đổi mật khẩu thành công!"));
    await tester.tap(find.widgetWithText(TextButton, "Đồng ý"));
    await tester.pumpAndSettle(const Duration(milliseconds: 300));

    await tester.tap(find.byKey(const ValueKey("back_screen")));
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    await tester.tap(find.text('Thông tin'));
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    expect(find.text('Thông tin tài khoản'), findsOneWidget);
    expect(find.byKey(const ValueKey("Họ và tên")), findsOneWidget);
    expect(find.byKey(const ValueKey("Giới tính")), findsOneWidget);
    expect(find.byKey(const ValueKey("Số điện thoại")), findsOneWidget);
    await tester.dragUntilVisible(
      find.byKey(const ValueKey("Số điện thoại")),
      find.byType(SingleChildScrollView),
      const Offset(0, 500),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    await tester.dragUntilVisible(
      find.byKey(const ValueKey("Tên ngân hàng")),
      find.byType(SingleChildScrollView),
      const Offset(0, 500),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    expect(find.byKey(const ValueKey("Tên ngân hàng")), findsOneWidget);
    expect(find.byKey(const ValueKey("Số tài khoản ngân hàng")), findsOneWidget);
    expect(find.byKey(const ValueKey("Tên chủ tài khoản")), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Cập nhật"), findsOneWidget);
    expect(find.byKey(const ValueKey("back_screen")), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey("Họ và tên")), '');
    await tester.enterText(find.byKey(const ValueKey("Số điện thoại")), '');
    await tester.enterText(find.byKey(const ValueKey("Tên ngân hàng")), '');
    await tester.enterText(find.byKey(const ValueKey("Số tài khoản ngân hàng")), '');
    await tester.enterText(find.byKey(const ValueKey("Tên chủ tài khoản")), '');
    await tapButtonPump(tester, 'Cập nhật');
    expect(find.descendant(of: find.byKey(const ValueKey("Họ và tên")), matching: find.text('Xin vui lòng nhập họ và tên')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const ValueKey("Số điện thoại")), matching: find.text('Xin vui lòng nhập số điện thoại')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const ValueKey("Tên ngân hàng")), matching: find.text('Xin vui lòng nhập tên ngân hàng')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const ValueKey("Số tài khoản ngân hàng")), matching: find.text('Xin vui lòng nhập số tài khoản ngân hàng')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const ValueKey("Tên chủ tài khoản")), matching: find.text('Xin vui lòng nhập tên chủ tài khoản')), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey("Họ và tên")), faker.person.name());
    await tester.enterText(find.byKey(const ValueKey("Số điện thoại")), faker.phoneNumber.random.fromPattern(['##########']));
    await tester.enterText(find.byKey(const ValueKey("Tên ngân hàng")), faker.person.name());
    await tester.enterText(find.byKey(const ValueKey("Số tài khoản ngân hàng")), faker.phoneNumber.random.fromPattern(['##########']));
    await tester.enterText(find.byKey(const ValueKey("Tên chủ tài khoản")), faker.person.name());
    await tapButtonPump(tester, 'Cập nhật');
    await pumpUntilFound(tester, find.text("Cập nhật thông tin tài khoản thành công"));
  });
}
