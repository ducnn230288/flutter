import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'pages.login.login.Register'.tr()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: CSpace.xl3),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: CSpace.xl3),
              child: WForm<MUser>(list: _listFormItem),
            ),
            const SizedBox(height: CSpace.xl3 * 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: CSpace.xl3),
              child: ElevatedButton(
                  onPressed: () => context.read<BlocC<MUser>>().submit(
                      api: (value, page, size, sort) => RepositoryProvider.of<Api>(context).auth.register(body: value),
                      submit: (data) => context.goNamed(CRoute.login)),
                  child: Text('pages.login.login.Register'.tr())),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("pages.login.register.Do you already have an account?".tr(), style: TextStyle(color: CColor.black.shade300, fontSize: CFontSize.sm)),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('pages.login.login.Log in'.tr(), style: const TextStyle(fontSize: CFontSize.sm)),
                )
              ],
            ),
          ],
        ),
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
    BlocC cubit = context.read<BlocC<MUser>>();
    _listFormItem = [
      MFormItem(label: 'Thông tin đăng ký', type: EFormItemType.title),
      MFormItem(name: 'email', label: 'pages.login.login.Email address'.tr(), keyBoard: EFormItemKeyBoard.email),
      MFormItem(
        name: 'password',
        label: 'pages.login.login.Password'.tr(),
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
        label: 'pages.login.register.Re-enter password'.tr(),
        password: true,
        onValidator: (value, listController) {
          if (value != null && listController['password']!.text != '' && value != listController['password']!.text) {
            return 'Mật khẩu không khớp';
          }
          return null;
        }
      ),
      MFormItem(
        type: EFormItemType.select,
        name: 'role',
        label: 'pages.login.register.Account Type'.tr(),
        items: [MOption(label: 'Order Side', value: 'ORDERER'), MOption(label: 'Farmer Side', value: 'FARMER')],
        onChange: (text, _) async {
          if (text == 'FARMER' && !_listFormItem[5].show) {
            _listFormItem[5].show = true;
            cubit.setList(list: _listFormItem);
          } else if (text != 'FARMER' && _listFormItem[5].show) {
            _listFormItem[5].show = false;
            cubit.removeKey(name: 'medicalDegreeCode');
            cubit.setList(list: _listFormItem);
          }
        }
      ),
      MFormItem(label: 'Thông tin cá nhân', type: EFormItemType.title),
      MFormItem(name: 'name', label: 'pages.login.register.Fullname'.tr()),
      MFormItem(
        type: EFormItemType.select,
        name: 'gender',
        label: 'pages.login.register.Gender'.tr(),
        items: [MOption(label: 'Nam', value: 'MALE'), MOption(label: 'Nữ', value: 'FEMALE')],
      ),
      MFormItem(
        name: 'phoneNumber',
        label: 'pages.login.register.Phone number'.tr(),
        keyBoard: EFormItemKeyBoard.phone,
      ),
    ];
  }
}
