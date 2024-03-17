import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';

class MyAccountPass extends StatefulWidget {
  const MyAccountPass({super.key});

  @override
  State<MyAccountPass> createState() => _MyAccountPassState();
}

class _MyAccountPassState extends State<MyAccountPass> {

  final Map<String, TextEditingController> _lstControllers = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Đổi mật khẩu'),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: CSpace.xl3),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: 160, child: CIcon.resetPassword),
                  WForm<MUser>(
                    list: _listFormItem,
                    onInit: (items) {
                      _lstControllers.addAll(items);
                    },
                  ),
                  const VSpacer(CSpace.xl3 * 2),
                  ElevatedButton(
                    onPressed: () {
                      context.read<BlocC<MUser>>().submit(
                        api: (value, _, __, ___) => RepositoryProvider.of<Api>(context).auth.updatePassword(body: value),
                        submit: (_) {
                          _lstControllers.forEach((key, value) { value.clear(); });
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

  @override
  void initState() {
    _init();
    super.initState();
  }

  List<MFormItem> _listFormItem = [];
  Future<void> _init() async {
    _listFormItem = [
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
        onValidator: (value, listController) {
          if (value != null && listController['confirmPassword']!.text != '' && value != listController['confirmPassword']!.text) {
            return 'Mật khẩu không khớp';
          }
          return null;
        }
      ),
      MFormItem(
        name: 'confirmPassword',
        label: 'Xác nhận mật khẩu mới',
        icon: 'assets/form/password.svg',
        password: true,
        onValidator: (value, listController) {
          if (value != null && listController['password']!.text != '' && value != listController['password']!.text) {
            return 'Mật khẩu không khớp';
          }
          return null;
        }
      ),
    ];
  }
}
