import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/constants/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';
import '/widgets/index.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  // handleSubmit() async {
  //   context.pushNamed(RoutesName.otpVerification, extra: 'Register');
  // }

  @override
  Widget build(BuildContext context) {
    BlocC cubit = context.read<BlocC>();

    final List<MFormItem> listFormItem = [
      MFormItem(name: 'name', label: 'pages.login.register.Fullname'.tr(), icon: 'assets/form/full-name.svg'),
      MFormItem(
        name: 'email',
        label: 'pages.login.login.Email address'.tr(),
        icon: 'assets/form/mail.svg',
      ),
      MFormItem(
          type: "select",
          name: 'gender',
          label: 'pages.login.register.Gender'.tr(),
          icon: 'assets/form/gender.svg',
          items: [MOption(label: 'Nam', value: 'MALE'), MOption(label: 'Nữ', value: 'FEMALE')]),
      MFormItem(
          name: 'password', label: 'pages.login.login.Password'.tr(), icon: 'assets/form/password.svg', password: true),
      MFormItem(
          name: 'confirmPassword',
          label: 'pages.login.register.Re-enter password'.tr(),
          icon: 'assets/form/password.svg',
          password: true),
      MFormItem(
          type: "select",
          name: 'role',
          label: 'pages.login.register.Account Type'.tr(),
          icon: 'assets/form/type-account.svg',
          items: [
            MOption(label: 'Order Side', value: 'ORDER_SIDE'),
            MOption(label: 'Farmer Side', value: 'FARMER_SIDE')
          ]),
      MFormItem(
          type: "select",
          name: 'professionalDegree',
          label: 'pages.login.register.Professional Degree'.tr(),
          icon: 'assets/form/degree.svg',
          show: false,
          items: [MOption(label: 'Bằng điều dưỡng', value: 'value1')])
    ];
    onChangeType(text) async {
      if (text == 'FARMER_SIDE' && !listFormItem[6].show) {
        listFormItem[6].show = true;
        cubit.setList(list: listFormItem);
      } else if (text != 'FARMER_SIDE' && listFormItem[6].show) {
        listFormItem[6].show = false;
        cubit.saved(name: 'degree', value: null);
        cubit.setList(list: listFormItem);
      }
    }

    listFormItem[5].onChange = onChangeType;

    return Scaffold(
      appBar: appBar(title: 'pages.login.login.Register'.tr()),
      body: SizedBox(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(
                height: CSpace.large,
              ),
              BlocListener<BlocC, BlocS>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: CSpace.large), child: WForm(list: listFormItem)),
              ),
              const SizedBox(
                height: CSpace.large * 2,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: CSpace.large),
                child: Column(
                  children: [
                    BlocConsumer<BlocC, BlocS>(
                      listenWhen: (context, state) => state.status == AppStatus.success,
                      listener: (context, state) => Navigator.pop(context),
                      builder: (context, state) => ElevatedButton(
                          onPressed: () => cubit.submit(
                              api: (value, page, size, sort) =>
                                  RepositoryProvider.of<Api>(context).auth.register(body: value)),
                          child: Text('pages.login.login.Register'.tr())),
                    ),
                    const SizedBox(
                      height: CSpace.large * 2,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "${'pages.login.register.Do you already have an account?'.tr()}? ",
                          children: [
                            TextSpan(
                                text: 'pages.login.login.Log in'.tr(),
                                style: TextStyle(color: CColor.primary),
                                recognizer: TapGestureRecognizer()..onTap = () => {Navigator.pop(context)})
                          ],
                          style: TextStyle(
                            color: CColor.black.shade300,
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: CSpace.large,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
