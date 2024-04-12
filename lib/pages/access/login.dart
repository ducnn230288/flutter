import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';
import '/widgets/index.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: CSpace.height - 523,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CIcon.logoLogin],
              ),
            ),
            Container(
              height: 510,
              padding: const EdgeInsets.all(CSpace.xl5),
              margin: const EdgeInsets.all(CSpace.base),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(33),
                boxShadow: [
                  BoxShadow(color: CColor.black.shade300.withOpacity(0.4), blurRadius: 6, offset: const Offset(1, 1))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: CSpace.xl5),
                    child: Text(
                      key: ValueKey("Đăng nhập"),
                      'Đăng nhập',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: CFontSize.xl3),
                    ),
                  ),
                  WForm<MUser>(list: _listFormItem),
                  const SizedBox(height: CSpace.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WButton(
                        type: TextButton,
                        onPressed: () => context.read<BlocC<MUser>>().savedBool(name: 'rememberMe'),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: BlocBuilder<BlocC<MUser>, BlocS<MUser>>(
                                builder: (context, state) {
                                  return Checkbox(
                                    side: BorderSide(width: 1, color: CColor.primary),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                    value: state.value['rememberMe'] != null && state.value['rememberMe'],
                                    onChanged: (bool? value) =>
                                        context.read<BlocC<MUser>>().savedBool(name: 'rememberMe'),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'pages.login.login.Remember me'.tr(),
                              style: TextStyle(fontSize: CFontSize.sm, color: CColor.black.shade300),
                            ),
                          ],
                        )),
                      WButton(
                        type: TextButton,
                        onPressed: () => context.goNamed(CRoute.forgotPassword),
                        child: Text('${'pages.login.login.Forgot password'.tr()}?', style: const TextStyle(fontSize: CFontSize.sm)),
                      )
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: CSpace.xl3),
                        Column(
                          children: [
                            Text("Bằng cách đăng nhập, bạn đã đồng ý với các", style: TextStyle(color: CColor.black.shade300, fontSize: CFontSize.sm)),
                            SizedBox(
                              height: 24,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  WButton(
                                    type: TextButton,
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.all(CSpace.xs),
                                    ),
                                    onPressed: () => {},
                                    child: const Text('Điều khoản dịch vụ', style: TextStyle(fontSize: CFontSize.sm)),
                                  ),
                                  Text("và", style: TextStyle(color: CColor.black.shade300, fontSize: CFontSize.sm, height: 1.3)),
                                  WButton(
                                    type: TextButton,
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.all(CSpace.xs),
                                    ),
                                    onPressed: () => {},
                                    child: const Text('Điều kiện bảo mật', style: TextStyle(fontSize: CFontSize.sm)),
                                  ),
                                ],
                              ),
                            ),
                            Text("của ứng dụng Uberental", style: TextStyle(color: CColor.black.shade300, fontSize: CFontSize.sm)),
                          ],
                        ),
                        const SizedBox(height: CSpace.xl3 * 2),
                        BlocConsumer<BlocC<MUser>, BlocS<MUser>>(
                            listenWhen: (context, state) => state.status == AppStatus.success,
                            listener: (context, state) => GoRouter.of(context).go(CRoute.home),
                            builder: (context, state) => WButton(
                              onPressed: () => context.read<BlocC<MUser>>().submit(
                                notification: false,
                                format: MUser.fromJson,
                                api: (value, page, size, sort) => RepositoryProvider.of<Api>(context).auth.login(body: value),
                                submit: (data) => context.read<AuthC>().save(data: data, context: context)),
                              child: Text('pages.login.login.Log in'.tr()))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("pages.login.login.You don't have an account yet?".tr(), style: TextStyle(color: CColor.black.shade300, fontSize: CFontSize.sm)),
                            WButton(
                              type: TextButton,
                              onPressed: () => context.pushNamed(CRoute.register),
                              child: Text('${'pages.login.login.Register'.tr()}?', style: const TextStyle(fontSize: CFontSize.sm)),
                            )
                          ],
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


  @override
  void initState() {
    _init();
    super.initState();
  }

  List<MFormItem> _listFormItem = [];
  Future<void> _init() async {
    _listFormItem = [
      MFormItem(name: 'username', hintText: 'pages.login.login.Email address'.tr(), icon: 'assets/form/mail.svg', keyBoard: EFormItemKeyBoard.email),
      MFormItem(name: 'password', hintText: 'pages.login.login.Password'.tr(), icon: 'assets/form/password.svg', password: true)
    ];
  }
}
