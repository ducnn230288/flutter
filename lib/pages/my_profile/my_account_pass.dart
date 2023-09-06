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
        name: 'password1',
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
            padding: const EdgeInsets.all(CSpace.large),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  WForm(
                    list: listFormItem,
                    onInit: (items) {
                      lstControllers.addAll(items);
                    },
                  ),
                  const VSpacer(CSpace.large * 2),
                  ElevatedButton(
                    onPressed: () => context.read<BlocC>().submit(
                          api: (value, _, __, ___) {
                            Map<String, dynamic> newValue = {};
                            value.forEach((key, value) {
                              newValue[key == 'password1' ? 'password' : key] = value;
                            });
                            return RepositoryProvider.of<Api>(context).auth.updatePassword(body: newValue);
                          },
                          submit: (_) => lstControllers.forEach((key, value) {
                            value.value = const TextEditingValue(text: '');
                          }),
                        ),
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
