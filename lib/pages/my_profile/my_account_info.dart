import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';

part '_account_info.dart';

class MyAccountInfo extends StatefulWidget {
  const MyAccountInfo({Key? key}) : super(key: key);

  @override
  State<MyAccountInfo> createState() => _MyAccountInfoState();
}

class _MyAccountInfoState extends State<MyAccountInfo> {
  String? currentUrl;
  late MUser? data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Thông tin tài khoản'),
      backgroundColor: Colors.white,
      body: BlocBuilder<AuthC, AuthS>(
        builder: (context, state) {
          if (state.status == AppStatus.success) {
            if (state.user == null) {
              return Container();
            }
            return _AccountInfo(user: state.user!);
          }
          if (state.status == AppStatus.inProcess) {
            return Center(
              child: WLoading(),
            );
          }

          return Container();
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(CSpace.medium),
          child: ElevatedButton(
            onPressed: () => context.read<BlocC>().submit(
                  api: (value, _, __, ___) => RepositoryProvider.of<Api>(context).auth.updateProfile(body: value),
                ),
            child: const Text('Cập nhật'),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    context.read<AuthC>().check(context: context);
    super.initState();
  }
}
