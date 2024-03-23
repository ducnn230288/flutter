import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'common.dart';
import 'package:faker/faker.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Register', (WidgetTester tester) async {
    final faker = Faker();
    await initAppWidgetTest(tester);

    await tester.tap(find.widgetWithText(TextButton, 'Tiếp tục'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Tiếp tục'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Bắt đầu'));
    await tester.pumpAndSettle();

    // await pumpUntilFound(tester, find.widgetWithText(TextButton, "Đăng ký?"));
    await tester.tap(find.widgetWithText(TextButton, "Đăng ký?"));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey("Đăng ký")), findsOneWidget);
    expect(find.byKey(const ValueKey("Thông tin đăng ký")), findsOneWidget);
    expect(find.byKey(const ValueKey("Địa chỉ Email")), findsOneWidget);
    expect(find.byKey(const ValueKey("Mật khẩu")), findsOneWidget);
    expect(find.byKey(const ValueKey("Nhập lại mật khẩu")), findsOneWidget);
    expect(find.byKey(const ValueKey("Loại tài khoản")), findsOneWidget);

    expect(find.byKey(const ValueKey("Thông tin cá nhân")), findsOneWidget);
    expect(find.byKey(const ValueKey("Họ và tên")), findsOneWidget);
    expect(find.byKey(const ValueKey("Giới tính")), findsOneWidget);
    expect(find.byKey(const ValueKey("Số điện thoại")), findsOneWidget);
    expect(find.byKey(const ValueKey("back_screen")), findsOneWidget);
    expect(find.widgetWithText(TextButton, "Đăng nhập"), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Đăng ký"), findsOneWidget);

    await tester.dragUntilVisible(
      find.widgetWithText(ElevatedButton, "Đăng ký"),
      find.byType(SingleChildScrollView),
      const Offset(0, 500),
    );
    await tester.tap(find.widgetWithText(ElevatedButton, "Đăng ký"));
    await tester.pumpAndSettle();

    expect(find.text("Xin vui lòng nhập địa chỉ email"), findsOneWidget);

    expect(find.text("Xin vui lòng nhập mật khẩu"), findsOneWidget);
    expect(find.text("Xin vui lòng nhập nhập lại mật khẩu"), findsOneWidget);
    expect(find.text("Xin vui lòng chọn loại tài khoản"), findsOneWidget);
    expect(find.text("Xin vui lòng nhập họ và tên"), findsOneWidget);
    expect(find.text("Xin vui lòng chọn giới tính"), findsOneWidget);
    expect(find.text("Xin vui lòng nhập số điện thoại"), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey("Địa chỉ Email")), faker.internet.email());
    final pass = faker.internet.userName();
    await tester.enterText(find.byKey(const ValueKey("Mật khẩu")), pass);
    await tester.enterText(find.byKey(const ValueKey("Nhập lại mật khẩu")), pass);

    await tester.dragUntilVisible(
      find.byKey(const ValueKey("Loại tài khoản")),
      find.byType(SingleChildScrollView),
      const Offset(0, 500),
    );
    await tester.tap(find.byKey(const ValueKey("Loại tài khoản")));
    await pumpUntilFound(tester, find.text('Farmer Side'));
    await tester.tap(find.text('Farmer Side'));

    await tester.enterText(find.byKey(const ValueKey("Họ và tên")), faker.person.name());

    await tester.dragUntilVisible(
      find.byKey(const ValueKey("Giới tính")),
      find.byType(SingleChildScrollView),
      const Offset(0, 500),
    );
    await tester.tap(find.byKey(const ValueKey("Giới tính")));
    await pumpUntilFound(tester, find.text('Nam'));
    await tester.tap(find.text('Nam'));

    await tester.enterText(find.byKey(const ValueKey("Số điện thoại")), faker.phoneNumber.de());

    await tester.dragUntilVisible(
      find.widgetWithText(ElevatedButton, "Đăng ký"),
      find.byType(SingleChildScrollView),
      const Offset(0, 500),
    );
    await tester.tap(find.widgetWithText(ElevatedButton, "Đăng ký"));

    await pumpUntilFound(tester, find.text("Đăng kí tài khoản thành công. Vui lòng kiểm tra email để xác thực tài khoản"));
    expect(find.text("Đăng kí tài khoản thành công. Vui lòng kiểm tra email để xác thực tài khoản"), findsOneWidget);
  });
}
