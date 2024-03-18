import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'common.dart';

void main() async {
  group('Login Flow Test', () {
    testWidgets('Should submit form when user email id & password is valid', (WidgetTester tester) async {
      await initAppWidgetTest(tester);

      await tester.tap(find.widgetWithText(TextButton, 'Tiếp tục'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Tiếp tục'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Bắt đầu'));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));

      expect(find.byKey(const ValueKey("Đăng nhập")), findsOneWidget);
      expect(find.byKey(const ValueKey("Địa chỉ Email")), findsOneWidget);
      expect(find.byKey(const ValueKey("Mật khẩu")), findsOneWidget);
      expect(find.text("Ghi nhớ tài khoản"), findsOneWidget);
      expect(find.text("Quên mật khẩu?"), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, "Đăng nhập"), findsOneWidget);
      expect(find.widgetWithText(TextButton, "Điều khoản dịch vụ"), findsOneWidget);
      expect(find.widgetWithText(TextButton, "Điều kiện bảo mật"), findsOneWidget);
      expect(find.widgetWithText(TextButton, "Đăng ký?"), findsOneWidget);

      await tester.tap(find.widgetWithText(ElevatedButton, "Đăng nhập"));
      await tester.pumpAndSettle();
      expect(find.text("Vui lòng nhập địa chỉ email"), findsOneWidget);
      expect(find.text("Vui lòng nhập mật khẩu"), findsOneWidget);

      await tester.enterText(find.byKey(const ValueKey("Địa chỉ Email")), 'random@gmail.com');
      await tester.enterText(find.byKey(const ValueKey("Mật khẩu")), '123123');

      await SystemChannels.textInput.invokeMethod('TextInput.hide');
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      await tester.tap(find.widgetWithText(ElevatedButton, "Đăng nhập"));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));

      expect(find.text("Tài khoản random@gmail.com không tồn tại trong hệ thống. Vui lòng đăng ký mới."), findsOneWidget);
      await tester.tap(find.widgetWithText(TextButton, "Thoát"));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const ValueKey("Địa chỉ Email")), 'admin@gmail.com');
      await tester.enterText(find.byKey(const ValueKey("Mật khẩu")), '123123123');

      await SystemChannels.textInput.invokeMethod('TextInput.hide');
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      await tester.tap(find.widgetWithText(ElevatedButton, "Đăng nhập"));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));

      expect(find.text("Sai mật khẩu cho tài khoản admin@gmail.com"), findsOneWidget);
      await tester.tap(find.widgetWithText(TextButton, "Thoát"));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const ValueKey("Địa chỉ Email")), 'admin@gmail.com');
      await tester.enterText(find.byKey(const ValueKey("Mật khẩu")), '123123');

      await SystemChannels.textInput.invokeMethod('TextInput.hide');
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      await tester.tap(find.widgetWithText(ElevatedButton, "Đăng nhập"));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));

      expect(find.text("Home"), findsOneWidget);
    });
  });
}
