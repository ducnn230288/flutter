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

  handleRegister() async {
    if (widgetFormNotifier.formKey.currentState!.validate()) {
      print(widgetFormNotifier.dataForm);
    }
  }

  @override
  Widget build(BuildContext context) {
    ModelForm modelForm = ModelForm.fromJson({
      "items": [
        {
          "name": "fullname",
          "placeholder": true,
          "label": 'Họ và tên',
          "icon": 'assets/svgs/fullname.svg',
          "required": true
        },
        {
          "name": "email",
          "placeholder": true,
          "label": 'Địa chỉ email',
          "icon": 'assets/svgs/mail.svg',
          "required": true
        },
        {
          "name": "password",
          "placeholder": true,
          "label": 'Mật khẩu',
          "icon": 'assets/svgs/password.svg',
          "required": true,
          "password": true
        },
        {
          "name": "confirmPassword",
          "placeholder": true,
          "label": 'Nhập lại mật khẩu',
          "icon": 'assets/svgs/password.svg',
          "required": true,
          "password": true
        },
        {
          "type": "select",
          "name": "type",
          "placeholder": true,
          "label": 'Loại tài khoản',
          "icon": 'assets/svgs/type-account.svg',
          "required": true,
          "items": [
            {
              'label': 'label',
              'value': 'value',
            }
          ]
        },
        {
          "type": "select",
          "name": "degree",
          "placeholder": true,
          "label": 'Bằng cấp chuyên môn',
          "icon": 'assets/svgs/degree.svg',
          "required": true,
          "items": [
            {
              'label': 'label',
              'value': 'value',
            }
          ]
        },
      ],
    });
    return Scaffold(
      appBar: appBar('Đăng ký', AppBar().preferredSize.height, context, MediaQuery.of(context).viewPadding.top - 15),
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
                  child: WidgetForm(modelForm: modelForm, widgetFormNotifier: widgetFormNotifier)),
              SizedBox(
                height: AppThemes.gap * 2,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppThemes.gap),
                child: Column(
                  children: [
                    ElevatedButton(onPressed: handleRegister, child: Text('Đăng nhập')),
                    SizedBox(
                      height: AppThemes.gap * 2,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "Ban đã có tài khoản? ",
                          children: [
                            TextSpan(
                                text: "Đăng nhập",
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
