import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(CSpace.xl3),
          children: [
            SizedBox(height: 170, child: CIcon.forgotPassword),
            const VSpacer(CSpace.xl5),
            const Center(
              child: Text(
                'Quên mật khẩu?',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: CFontSize.xl2),
              ),
            ),
            const VSpacer(CSpace.xl5),
            Text(
              'Đừng lo, hãy nhập email đã đăng ký của bạn bên dưới để nhận mã OTP xác nhận lấy lại mật khẩu',
              style: TextStyle(color: CColor.black.shade300),
              textAlign: TextAlign.center,
            ),
            const VSpacer(CSpace.xl5),
            WForm<MUser>(
              list: [
                MFormItem(
                  name: 'email',
                  label: 'pages.login.login.Email address'.tr(),
                  icon: 'assets/form/mail.svg',
                  keyBoard: EFormItemKeyBoard.email
                ),
              ],
            ),
            const VSpacer(CSpace.xl3),
            ElevatedButton(
              onPressed: () => context.read<BlocC<MUser>>().submit(
                api: (value, _, __, ___) => RepositoryProvider.of<Api>(context).auth.forgotPassword(email: value['email']),
                submit: (data) => context.goNamed(
                  CRoute.otpVerification,
                  queryParameters: {'email': context.read<BlocC<MUser>>().state.value['email']},
                )),
              child: const Text('Gửi'))
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(CSpace.xl3),
          child: TextButton(
            onPressed: () => context.pop(),
            child: Text('Quay lại đăng nhập', style: TextStyle(color: CColor.black, fontWeight: FontWeight.w500)),
          ),
        ),
      ),
    );
  }
}
