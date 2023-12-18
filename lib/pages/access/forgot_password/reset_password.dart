import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';

class ResetPassword extends StatelessWidget {
  final String resetPasswordToken;

  const ResetPassword({Key? key, required this.resetPasswordToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<MFormItem> listFormItem = [
      MFormItem(
        name: 'newPassword',
        label: 'Mật khẩu mới',
        hintText: 'Nhập',
        password: true,
      ),
      MFormItem(
        name: 'password',
        label: 'Xác nhận mật khẩu mới',
        hintText: 'Nhập',
        password: true,
      )
    ];
    return Scaffold(
      appBar: appBar(title: 'Tạo mật khẩu mới'),
      body: ListView(
        padding: const EdgeInsets.all(CSpace.superLarge),
        children: [
          SizedBox(height: 170, child: CIcon.resetPassword),
          const VSpacer(CSpace.superLarge),
          const Text(
            'Bây giờ bạn có thể đặt lại mật khẩu mới cho mình được rồi!',
            textAlign: TextAlign.center,
          ),
          const VSpacer(CSpace.superLarge),
          WForm<MUser>(list: listFormItem),
          const VSpacer(CSpace.superLarge),
          ElevatedButton(
              onPressed: () {
                final value = context.read<BlocC<MUser>>().state.value;
                if (value['newPassword'] != value['password']) {
                  UDialog().showError(text: 'Xác nhận mật khẩu sai');
                  return;
                }
                context.read<BlocC<MUser>>().submit(
                    api: (_, __, ___, ____) => RepositoryProvider.of<Api>(context)
                        .auth
                        .resetPassword(resetPasswordToken: resetPasswordToken, password: value['password']),
                    submit: (data) => context.goNamed(CRoute.login));
              },
              child: const Text('Xác nhận'))
        ],
      ),
    );
  }
}
