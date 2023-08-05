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

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<MFormItem> listFormItem = [
      MFormItem(
        name: 'username',
        hintText: 'pages.login.login.Email address'.tr(),
        icon: 'assets/form/mail.svg',
      ),
      MFormItem(
        name: 'password',
        hintText: 'pages.login.login.Password'.tr(),
        icon: 'assets/form/password.svg',
        password: true,
      )
    ];
    List<MFormItem> listEmail = [
      MFormItem(
        name: 'email',
        hintText: 'pages.login.login.Email address'.tr(),
        icon: 'assets/form/mail.svg',
      ),
    ];

    return Scaffold(
      // appBar: appBar(title: 'pages.login.login.Log in'.tr()),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: CSpace.height - 552,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CIcon.logoLogin],
              ),
            ),
            Container(
              height: 502,
              padding: const EdgeInsets.all(CSpace.superLarge),
              margin: const EdgeInsets.all(CSpace.mediumSmall),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(33),
                boxShadow: [
                  BoxShadow(color: CColor.hintColor.withOpacity(0.4), blurRadius: 6, offset: const Offset(1, 1))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: CSpace.superLarge),
                    child: Text(
                      'Đăng nhập',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: CFontSize.title1),
                    ),
                  ),
                  WForm(list: listFormItem),
                  const SizedBox(height: CSpace.small),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () => context.read<BlocC>().savedBool(name: 'rememberMe'),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: BlocBuilder<BlocC, BlocS>(
                                  builder: (context, state) {
                                    return Checkbox(
                                      side: BorderSide(width: 1, color: CColor.primary),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                      value: state.value['rememberMe'] != null && state.value['rememberMe'],
                                      onChanged: (bool? value) => context.read<BlocC>().savedBool(name: 'rememberMe'),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'pages.login.login.Remember me'.tr(),
                                style: TextStyle(fontSize: CFontSize.footnote, color: CColor.hintColor),
                              ),
                            ],
                          )),
                      TextButton(
                        onPressed: () => context.goNamed(CRoute.forgotPassword),
                        child: Text('${'pages.login.login.Forgot password'.tr()}?'),
                      )
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(text: 'Bằng cách đăng nhập, bạn đã đồng ý với các\n'),
                              TextSpan(
                                text: ' Điều khoản dịch vụ',
                                style: TextStyle(color: CColor.primary, fontSize: CFontSize.footnote),
                              ),
                              const TextSpan(text: ' và '),
                              TextSpan(
                                text: 'Điều kiện bảo mật ',
                                style: TextStyle(color: CColor.primary, fontSize: CFontSize.footnote),
                              ),
                              const TextSpan(text: 'của ứng dụng Uberental')
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: CFontSize.footnote),
                        ),
                        const SizedBox(height: CSpace.large * 2),
                        BlocConsumer<BlocC, BlocS>(
                            listenWhen: (context, state) => state.status == AppStatus.success,
                            listener: (context, state) => GoRouter.of(context).go(CRoute.home),
                            builder: (context, state) => ElevatedButton(
                                onPressed: () => context.read<BlocC>().submit(
                                    notification: false,
                                    api: (value, page, size, sort) =>
                                        RepositoryProvider.of<Api>(context).auth.login(body: value),
                                    submit: (data) => context.read<AuthC>().save(data: data)),
                                child: Text('pages.login.login.Log in'.tr()))),
                        const SizedBox(height: CSpace.large * 2),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: "pages.login.login.You don't have an account yet?".tr(),
                              children: [
                                TextSpan(
                                    text: 'pages.login.login.Register'.tr(),
                                    style: TextStyle(color: CColor.primary),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => context.pushNamed(CRoute.register))
                              ],
                              style: TextStyle(color: CColor.hintColor)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
