import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../constants/index.dart';
import '../../cubit/index.dart';
import '../../models/form.dart';
import '../../utils/index.dart';
import '../../widgets/index.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  // bool rememberMe = false;
  // handleSubmit() async {
  //   if (formNotifier.formKey.currentState!.validate()) {
  //     // Dialogs(context).startLoading();
  //     formNotifier.dataForm['rememberMe'] = rememberMe;
  //     print(formNotifier.dataForm);
  //     // Navigator.pushNamed(context, RoutesName.registerPage);
  //   }
  // }
  //

  @override
  Widget build(BuildContext context) {
    List<ModelFormItem> listFormItem = [
      ModelFormItem(name: 'loginName', label: 'Địa chỉ Email', icon: 'assets/form/mail.svg'),
      ModelFormItem(name: 'password', label: 'Mật khẩu', icon: 'assets/form/password.svg', password: true)
    ];
    List<ModelFormItem> listEmail = [
      ModelFormItem(name: 'email', label: 'Địa chỉ Email', icon: 'assets/form/mail.svg'),
    ];
    handleEmail() async {
      GoRouter.of(context).pushNamed(RoutesName.otpVerification, extra: 'Email');
    }

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
                      builder: (context, state) {
                        return TextButton(
                            onPressed: () => context.read<AppFormCubit>().savedBool(name: 'rememberMe'),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    side: BorderSide(width: 1, color: ColorName.primary),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                    value: state.data['rememberMe'] != null && state.data['rememberMe'],
                                    onChanged: (bool? value) {},
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text('Lưu mật khẩu'),
                              ],
                            ));
                      },
                    ),
                    TextButton(
                        onPressed: () => Dialogs(context).showForm(
                            title: 'Quên mật khẩu',
                            formItem: listEmail,
                            submit: handleEmail,
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
                    BlocBuilder<AppFormCubit, AppFormState>(
                      builder: (context, state) {
                        return ElevatedButton(
                            onPressed: () => context.read<AppFormCubit>().submit(), child: const Text('Đăng nhập'));
                      },
                    ),
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
