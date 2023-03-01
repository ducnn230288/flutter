import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/constants/index.dart';
import '/cubit/index.dart';
import '/models/form.dart';
import '/utils/index.dart';
import '/widgets/index.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AppAuthCubit auth = context.read<AppAuthCubit>();

    List<ModelFormItem> listFormItem = [
      ModelFormItem(name: 'username', label: 'Địa chỉ Email', icon: 'assets/form/mail.svg'),
      ModelFormItem(name: 'password', label: 'Mật khẩu', icon: 'assets/form/password.svg', password: true)
    ];
    List<ModelFormItem> listEmail = [
      ModelFormItem(name: 'email', label: 'Địa chỉ Email', icon: 'assets/form/mail.svg'),
    ];

    return Scaffold(
      appBar: appBar(title: 'Đăng nhập', context: context),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: Space.large), child: WidgetForm(list: listFormItem)),
              const SizedBox(
                height: Space.large / 4,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: Space.large / 2.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<AppFormCubit, AppFormState>(
                      builder: (context, state) => TextButton(
                          onPressed: () => context.read<AppFormCubit>().savedBool(name: 'rememberMe'),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  side: BorderSide(width: 1, color: ColorName.primary),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                  value: state.value['rememberMe'] != null && state.value['rememberMe'],
                                  onChanged: (bool? value) {},
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text('Lưu mật khẩu'),
                            ],
                          )),
                    ),
                    TextButton(
                        onPressed: () => Dialogs(context).showForm(
                            title: 'Quên mật khẩu',
                            formItem: listEmail,
                            api: (body, logout) =>
                                RepositoryProvider.of<Api>(context).forgotPassword(email: body['email']),
                            textButton: 'Cấp lại mật khẩu'),
                        child: const Text('Quên mật khẩu?'))
                  ],
                ),
              ),
              const SizedBox(
                height: Space.large * 2,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: Space.large),
                child: Column(
                  children: [
                    Text(
                      'Bằng cách đăng nhập, bạn đã đồng ý với các điều khoản dịch vụ và điều kiện bảo mật của ứng dụng',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: ColorName.black.shade300),
                    ),
                    const SizedBox(
                      height: Space.large * 4,
                    ),
                    BlocConsumer<AppFormCubit, AppFormState>(
                        listenWhen: (context, state) => state.status == AppStatus.success,
                        listener: (context, state) => GoRouter.of(context).go(
                              RoutesName.home,
                            ),
                        builder: (context, state) => ElevatedButton(
                            onPressed: () => context.read<AppFormCubit>().submit(
                                context: context,
                                auth: auth,
                                api: (body, logout) => RepositoryProvider.of<Api>(context).login(body: body),
                                submit: (data) => context.read<AppAuthCubit>().save(data: data)),
                            child: const Text('Đăng nhập'))),
                    const SizedBox(
                      height: Space.large * 2,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "Ban chưa có tài khoản? ",
                          children: [
                            TextSpan(
                                text: "Đăng ký",
                                style: TextStyle(color: ColorName.primary),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => context.pushNamed(RoutesName.register))
                          ],
                          style: TextStyle(color: ColorName.black.shade300)),
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
