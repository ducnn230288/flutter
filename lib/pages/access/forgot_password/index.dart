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
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double size = CSpace.width < 190 ? 190 : CSpace.width * 0.6;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(CSpace.large),
          children: [
            const VSpacer(CSpace.superLarge),
            CIcon.reminder,
            const VSpacer(CSpace.mediumSmall),
            const Center(
              child: Text(
                'Quên mật khẩu?',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: CFontSize.title2),
              ),
            ),
            const VSpacer(CSpace.medium),
            Text(
              'Đừng lo, hãy nhập email đã đăng ký của bạn bên dưới để nhận mã OTP xác nhận lấy lại mật khẩu',
              style: TextStyle(color: CColor.hintColor),
              textAlign: TextAlign.center,
            ),
            const VSpacer(CSpace.superLarge),
            WForm(
              list: [
                MFormItem(
                  name: 'email',
                  label: 'pages.login.login.Email address'.tr(),
                  icon: 'assets/form/mail.svg',
                ),
              ],
            ),
            const VSpacer(CSpace.large),
            ElevatedButton(
                onPressed: () => context.read<BlocC>().submit(
                    api: (value, _, __, ___) =>
                        RepositoryProvider.of<Api>(context).auth.forgotPassword(email: value['email']),
                    submit: (data) => context.goNamed(
                          CRoute.otpVerification,
                          queryParams: {'email': context.read<BlocC>().state.value['email']},
                        )),
                child: const Text('Gửi'))
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(CSpace.large),
          child: TextButton(
            onPressed: () => context.pop(),
            child: Text('Quay lại đăng nhập', style: TextStyle(color: CColor.black, fontWeight: FontWeight.w500)),
          ),
        ),
      ),
    );
  }
}
