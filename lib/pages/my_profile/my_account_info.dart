import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';

part '_account_info.dart';

class MyAccountInfo extends StatefulWidget {
  const MyAccountInfo({super.key});

  @override
  State<MyAccountInfo> createState() => _MyAccountInfoState();
}

class _MyAccountInfoState extends State<MyAccountInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Thông tin tài khoản'),
      backgroundColor: Colors.white,
      body: BlocBuilder<AuthC, AuthS>(
        builder: (context, state) {
          return state.user != null && state.status == AppStatus.success
              ? _AccountInfo(user: state.user!)
              : const Center(child: WLoading());
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(CSpace.xl),
          child: ElevatedButton(
            onPressed: () => context.read<BlocC<MUser>>().submit(
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
