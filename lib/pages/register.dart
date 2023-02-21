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
  handleLogin(values) async {
    print(values);
  }

  @override
  Widget build(BuildContext context) {
    ModelForm modelForm = ModelForm.fromJson({
      "submit": handleLogin,
      "textSubmit": "LOG IN",
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
          "password": true
        },
        {
          "type": "select",
          "name": "degree",
          "placeholder": true,
          "label": 'Bằng cấp chuyên môn',
          "icon": 'assets/svgs/degree.svg',
          "required": true,
          "password": true
        },
      ],
    });
    return Scaffold(
      appBar: appBar('Đăng ký', AppBar().preferredSize.height, context, MediaQuery.of(context).viewPadding.top - 20),
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: AppThemes.gap), child: WidgetForm(modelForm: modelForm)),
              SizedBox(
                height: AppThemes.gap * 2,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppThemes.gap),
                child: Column(
                  children: [
                    ElevatedButton(onPressed: () {}, child: Text('Đăng nhập')),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
