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
          "name": "loginName",
          "placeholder": true,
          "label": 'Địa chỉ Email',
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
      ],
    });
    return Scaffold(
      appBar: appBar('Đăng nhập', AppBar().preferredSize.height, context, MediaQuery.of(context).viewPadding.top - 20),
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
                height: AppThemes.gap / 4,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppThemes.gap / 2.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                side: BorderSide(width: 1, color: AppThemes.primaryColor),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                value: false,
                                onChanged: (bool? value) {},
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text('Lưu mật khẩu'),
                          ],
                        )),
                    TextButton(onPressed: () {}, child: const Text('Quên mật khẩu?'))
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
                    ElevatedButton(onPressed: () {}, child: Text('Đăng nhập')),
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
