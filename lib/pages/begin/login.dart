import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '/models.dart';
import '/utils.dart';
import '/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final WidgetFormNotifier formNotifier = WidgetFormNotifier();
  List<ModelFormItem> listFormItem = [
    ModelFormItem(name: 'loginName', label: 'Địa chỉ Email', icon: 'assets/svgs/mail.svg', email: true),
    ModelFormItem(name: 'password', label: 'Mật khẩu', icon: 'assets/svgs/password.svg', password: true)
  ];
  bool rememberMe = false;
  handleSubmit() async {
    if (formNotifier.formKey.currentState!.validate()) {
      // Dialogs(context).startLoading();
      formNotifier.dataForm['rememberMe'] = rememberMe;
      print(formNotifier.dataForm);
      // Navigator.pushNamed(context, RoutesName.registerPage);
    }
  }

  List<ModelFormItem> listEmail = [
    ModelFormItem(name: 'loginName', label: 'Địa chỉ Email', icon: 'assets/svgs/mail.svg', email: true),
  ];
  handleEmail(data) async {
    print(data);
    Navigator.pushNamed(context, RoutesName.otpVerificationPage, arguments: 'Email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Đăng nhập', context: context),
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: AppThemes.gap),
                  child: WidgetForm(list: listFormItem, notifier: formNotifier)),
              SizedBox(
                height: AppThemes.gap / 4,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppThemes.gap / 2.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () => setState(() {
                              rememberMe = !rememberMe;
                            }),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                side: BorderSide(width: 1, color: AppThemes.primaryColor),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                value: rememberMe,
                                onChanged: (bool? value) {},
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text('Lưu mật khẩu'),
                          ],
                        )),
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
              SizedBox(
                height: AppThemes.gap * 2,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppThemes.gap),
                child: Column(
                  children: [
                    Text(
                      'Bằng cách đăng nhập, bạn đã đồng ý với các điều khoản dịch vụ và điều kiện bảo mật của ứng dụng',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppThemes.hintColor),
                    ),
                    SizedBox(
                      height: AppThemes.gap * 4,
                    ),
                    ElevatedButton(onPressed: handleSubmit, child: const Text('Đăng nhập')),
                    SizedBox(
                      height: AppThemes.gap * 2,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "Ban chưa có tài khoản? ",
                          children: [
                            TextSpan(
                                text: "Đăng ký",
                                style: TextStyle(color: AppThemes.primaryColor),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => {Navigator.pushNamed(context, RoutesName.registerPage)})
                          ],
                          style: TextStyle(color: AppThemes.grayColor)),
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
