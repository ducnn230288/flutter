import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '/constants.dart';
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
    ModelFormItem(name: 'fullname', placeholder: true, label: 'Họ và tên', icon: 'assets/form/fullname.svg'),
    ModelFormItem(
      name: 'email',
      label: 'Địa chỉ email',
      icon: 'assets/form/mail.svg',
      email: true,
    ),
    ModelFormItem(name: 'password', label: 'Mật khẩu', icon: 'assets/form/password.svg', password: true),
    ModelFormItem(
        name: 'confirmPassword', label: 'Nhập lại mật khẩu', icon: 'assets/form/password.svg', password: true),
    ModelFormItem(type: "select", name: 'type', label: 'Loại tài khoản', icon: 'assets/form/type-account.svg', items: [
      ModelOption(label: 'Order Side', value: 'value1'),
      ModelOption(label: 'Farmer Side', value: 'value2'),
    ]),
    ModelFormItem(
        type: "select",
        name: 'degree',
        label: 'Bằng cấp chuyên môn',
        icon: 'assets/form/degree.svg',
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
              const SizedBox(
                height: Space.large,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: Space.large),
                  child: WidgetForm(list: listFormItem, notifier: widgetFormNotifier)),
              const SizedBox(
                height: Space.large * 2,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: Space.large),
                child: Column(
                  children: [
                    ElevatedButton(onPressed: handleSubmit, child: Text('Đăng nhập')),
                    const SizedBox(
                      height: Space.large * 2,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "Ban đã có tài khoản? ",
                          children: [
                            TextSpan(
                                text: "Đăng ký",
                                style: TextStyle(color: ColorName.primary),
                                recognizer: TapGestureRecognizer()..onTap = () => {Navigator.pop(context)})
                          ],
                          style: TextStyle(
                            color: ColorName.black.shade300,
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: Space.large,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
