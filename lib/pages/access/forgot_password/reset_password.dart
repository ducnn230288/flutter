import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';

class ResetPassword extends StatefulWidget {
  final String resetPasswordToken;

  const ResetPassword({super.key, required this.resetPasswordToken});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Tạo mật khẩu mới'),
      body: ListView(
        padding: const EdgeInsets.all(CSpace.xl5),
        children: [
          SizedBox(height: 170, child: CIcon.resetPassword),
          const VSpacer(CSpace.xl5),
          const Text(
            'Bây giờ bạn có thể đặt lại mật khẩu mới cho mình được rồi!',
            textAlign: TextAlign.center,
          ),
          const VSpacer(CSpace.xl5),
          WForm<MUser>(list: _listFormItem),
          const VSpacer(CSpace.xl5),
          ElevatedButton(
            onPressed: () {
              context.read<BlocC<MUser>>().submit(
                api: (value, __, ___, ____) => RepositoryProvider.of<Api>(context).auth.resetPassword(
                  resetPasswordToken: widget.resetPasswordToken,
                  password: value['password']
                ),
                submit: (data) => context.goNamed(CRoute.login));
            },
            child: const Text('Xác nhận'))
        ],
      ),
    );
  }


  @override
  void initState() {
    _init();
    super.initState();
  }

  List<MFormItem> _listFormItem = [];
  Future<void> _init() async {
    _listFormItem = [
      MFormItem(
        name: 'newPassword',
        label: 'Mật khẩu mới',
        hintText: 'Nhập',
        password: true,
        onValidator: (value, listController) {
          if (value != null && listController['password']!.text != '' && value != listController['password']!.text) {
            return 'Mật khẩu không khớp';
          }
          return null;
        }
      ),
      MFormItem(
        name: 'password',
        label: 'Xác nhận mật khẩu mới',
        hintText: 'Nhập',
        password: true,
        onValidator: (value, listController) {
          if (value != null && listController['newPassword']!.text != '' && value != listController['newPassword']!.text) {
            return 'Mật khẩu không khớp';
          }
          return null;
        }
      )
    ];
  }
}
