import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '/models.dart';
import '/utils.dart';
import '/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with TickerProviderStateMixin {
  final WidgetFormNotifier widgetFormNotifier = WidgetFormNotifier();
  List<ModelFormItem> listFormItem = [
    ModelFormItem(name: 'fullname', placeholder: true, label: 'Họ và tên', icon: 'assets/svgs/fullname.svg'),
    ModelFormItem(
      name: 'email',
      label: 'Địa chỉ email',
      icon: 'assets/svgs/mail.svg',
      email: true,
    ),
    ModelFormItem(name: 'password', label: 'Mật khẩu', icon: 'assets/svgs/password.svg', password: true),
    ModelFormItem(
        name: 'confirmPassword', label: 'Nhập lại mật khẩu', icon: 'assets/svgs/password.svg', password: true),
    ModelFormItem(type: "select", name: 'type', label: 'Loại tài khoản', icon: 'assets/svgs/type-account.svg', items: [
      ModelOption(label: 'Order Side', value: 'value1'),
      ModelOption(label: 'Farmer Side', value: 'value2'),
    ]),
    ModelFormItem(
        type: "select",
        name: 'degree',
        label: 'Bằng cấp chuyên môn',
        icon: 'assets/svgs/degree.svg',
        show: false,
        items: [
          ModelOption(label: 'Bằng điều dưỡng', value: 'value1'),
        ])
  ];
  onChangeType(String text) async {
    if (text == 'value2') {
      setState(() {
        listFormItem[5].show = true;
      });
    } else if (listFormItem[5].show) {
      setState(() {
        widgetFormNotifier.dataForm['degree'] = null;
        listFormItem[5].show = false;
      });
    }
  }

  handleSubmit() async {
    if (widgetFormNotifier.formKey.currentState!.validate()) {
      print(widgetFormNotifier.dataForm);
      Navigator.pushNamed(context, RoutesName.otpVerificationPage, arguments: 'Register');
    }
  }

  @override
  Widget build(BuildContext context) {
    listFormItem[4].onChange = onChangeType;

    return Scaffold(
      appBar: appBar(title: 'Đăng ký', context: context),
      backgroundColor: Colors.white,
      body: SizedBox(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: AppThemes.gap,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: AppThemes.gap),
                  child: WidgetForm(list: listFormItem, notifier: widgetFormNotifier)),
              SizedBox(
                height: AppThemes.gap * 2,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppThemes.gap),
                child: Column(
                  children: [
                    ElevatedButton(onPressed: handleSubmit, child: Text('Đăng nhập')),
                    SizedBox(
                      height: AppThemes.gap * 2,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "Ban đã có tài khoản? ",
                          children: [
                            TextSpan(
                                text: "Đăng ký",
                                style: TextStyle(color: AppThemes.primaryColor),
                                recognizer: TapGestureRecognizer()..onTap = () => {Navigator.pop(context)})
                          ],
                          style: TextStyle(
                            color: AppThemes.grayColor,
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: AppThemes.gap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
