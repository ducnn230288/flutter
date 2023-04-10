import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/constants/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';
import '/widgets/index.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<MFormItem> listFormItem = [
      MFormItem(name: 'username', label: 'pages.login.login.Email address'.tr(), icon: 'assets/form/mail.svg'),
      MFormItem(
          name: 'password', label: 'pages.login.login.Password'.tr(), icon: 'assets/form/password.svg', password: true)
    ];
    List<MFormItem> listEmail = [
      MFormItem(name: 'email', label: 'pages.login.login.Email address'.tr(), icon: 'assets/form/mail.svg'),
    ];

    return Scaffold(
      appBar: appBar(title: 'pages.login.login.Log in'.tr()),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: CSpace.large), child: WForm(list: listFormItem)),
              const SizedBox(
                height: CSpace.large / 4,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: CSpace.large / 2.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<BlocC, BlocS>(
                      builder: (context, state) => TextButton(
                          onPressed: () => context.read<BlocC>().savedBool(name: 'rememberMe'),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  side: BorderSide(width: 1, color: CColor.primary),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                  value: state.value['rememberMe'] != null && state.value['rememberMe'],
                                  onChanged: (bool? value) {},
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text('pages.login.login.Remember me'.tr()),
                            ],
                          )),
                    ),
                    TextButton(
                        onPressed: () => UDialog().showForm(
                            title: 'pages.login.login.Forgot password'.tr(),
                            formItem: listEmail,
                            api: (value, page, size, sort) =>
                                RepositoryProvider.of<Api>(context).auth.forgotPassword(email: value['email']),
                            textButton: 'pages.login.login.Password reset'.tr()),
                        child: Text('${'pages.login.login.Forgot password'.tr()}?'))
                  ],
                ),
              ),
              const SizedBox(
                height: CSpace.large * 2,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: CSpace.large),
                child: Column(
                  children: [
                    Text(
                      'pages.login.login.terms of service'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: CColor.black.shade300),
                    ),
                    const SizedBox(
                      height: CSpace.large * 4,
                    ),
                    BlocConsumer<BlocC, BlocS>(
                        listenWhen: (context, state) => state.status == AppStatus.success,
                        listener: (context, state) => GoRouter.of(context).go(
                              CRoute.home,
                            ),
                        builder: (context, state) => ElevatedButton(
                            onPressed: () => context.read<BlocC>().submit(
                                api: (value, page, size, sort) =>
                                    RepositoryProvider.of<Api>(context).auth.login(body: value),
                                submit: (data) => context.read<AuthC>().save(data: data)),
                            child: Text('pages.login.login.Log in'.tr()))),
                    const SizedBox(
                      height: CSpace.large * 2,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "pages.login.login.You don't have an account yet?".tr(),
                          children: [
                            TextSpan(
                                text: 'pages.login.login.Register'.tr(),
                                style: TextStyle(color: CColor.primary),
                                recognizer: TapGestureRecognizer()..onTap = () => context.pushNamed(CRoute.register))
                          ],
                          style: TextStyle(color: CColor.black.shade300)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
