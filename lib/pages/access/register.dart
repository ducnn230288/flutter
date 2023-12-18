import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocC cubit = context.read<BlocC<MUser>>();

    final List<MFormItem> listFormItem = [
      MFormItem(label: 'Thông tin đăng ký', type: EFormItemType.title),
      MFormItem(
        name: 'email',
        label: 'pages.login.login.Email address'.tr(),
        keyBoard: EFormItemKeyBoard.email,
      ),
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
      ),
      MFormItem(label: 'Thông tin cá nhân', type: EFormItemType.title),
      MFormItem(
        name: 'name',
        label: 'pages.login.register.Fullname'.tr(),
      ),
      MFormItem(
        type: EFormItemType.select,
        name: 'gender',
        label: 'pages.login.register.Gender'.tr(),
        items: [MOption(label: 'Nam', value: 'MALE'), MOption(label: 'Nữ', value: 'FEMALE')],
      ),
      MFormItem(
        name: 'phoneNumber',
        label: 'pages.login.register.Phone number'.tr(),
        keyBoard: EFormItemKeyBoard.number,
        formatNumberType: FormatNumberType.normal,
      ),
    ];

    listFormItem[4].onChange = (text, _) async {
      if (text == 'FARMER' && !listFormItem[5].show) {
        listFormItem[5].show = true;
        cubit.setList(list: listFormItem);
      } else if (text != 'FARMER' && listFormItem[5].show) {
        listFormItem[5].show = false;
        cubit.removeKey(name: 'medicalDegreeCode');
        cubit.setList(list: listFormItem);
      }
    };

    return Scaffold(
      appBar: appBar(title: 'pages.login.login.Register'.tr()),
      body: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: CSpace.large),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: CSpace.large),
            child: WForm<MUser>(list: listFormItem),
          ),
          const SizedBox(height: CSpace.large * 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: CSpace.large),
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () => cubit.submit(
                        api: (value, page, size, sort) =>
                            RepositoryProvider.of<Api>(context).auth.register(body: value),
                        submit: (data) => context.goNamed(CRoute.login)),
                    child: Text('pages.login.login.Register'.tr())),
                const SizedBox(height: CSpace.large * 2),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "${'pages.login.register.Do you already have an account?'.tr()} ",
                      children: [
                        TextSpan(
                            text: 'pages.login.login.Log in'.tr(),
                            style: TextStyle(color: CColor.primary),
                            recognizer: TapGestureRecognizer()..onTap = () => Navigator.pop(context))
                      ],
                      style: TextStyle(color: CColor.black.shade300)),
                ),
              ],
            ),
          ),
          const SizedBox(height: CSpace.large),
        ],
      ),
    );
  }
}
