import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';

class MyAccountPass extends StatefulWidget {
  const MyAccountPass({Key? key}) : super(key: key);

  @override
  State<MyAccountPass> createState() => _MyAccountPassState();
}

class _MyAccountPassState extends State<MyAccountPass> {
  Map<String, TextEditingController> lstControllers = {};

  @override
  Widget build(BuildContext context) {
    List<MFormItem> listFormItem = [
      MFormItem(
        name: 'oldPassword',
        label: 'Mật khẩu cũ',
        icon: 'assets/form/password.svg',
        password: true,
      ),
      MFormItem(
        name: 'password',
        label: 'Mật khẩu mới',
        icon: 'assets/form/password.svg',
        password: true,
      ),
      MFormItem(
        name: 'confirmPassword',
        label: 'Xác nhận mật khẩu mới',
        icon: 'assets/form/password.svg',
        password: true,
      ),
    ];

    return Scaffold(
      appBar: appBar(title: 'Đổi mật khẩu'),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: CSpace.large),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: 160, child: CIcon.resetPassword),
                  WForm<MUser>(
                    list: listFormItem,
                    onInit: (items) {
                      lstControllers.addAll(items);
                    },
                  ),
                  const VSpacer(CSpace.large * 2),
                  ElevatedButton(
                    onPressed: () {
                      context.read<BlocC<MUser>>().submit(
                        api: (value, _, __, ___) {
                          if (value['password'] != value['confirmPassword']) {
                            UDialog().stopLoading();
                            UDialog().showError(text: 'Nhập lại mật khẩu sai');
                            return null;
                          }
                          return RepositoryProvider.of<Api>(context).auth.updatePassword(body: value);
                        },
                        submit: (_) {
                          lstControllers.forEach((key, value) {
                            value.clear();
                          });
                          Future.delayed(const Duration(milliseconds: 30), () {
                            context.read<BlocC<MUser>>().savedStatus(status: AppStatus.init);
                          });
                        },
                      );
                    },
                    child: const Text('Cập nhật'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
