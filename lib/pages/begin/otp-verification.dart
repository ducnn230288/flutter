import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '/utils.dart';
import '/widgets.dart';

class OTPVerificationPage extends StatefulWidget {
  final String status;
  const OTPVerificationPage({Key? key, required this.status}) : super(key: key);

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> with TickerProviderStateMixin {
  final controller = TextEditingController();

  handleSubmit() async {
    if (controller.value.text.length == 6) {
      Navigator.pushNamed(context, RoutesName.loginPage);
      Dialogs(context)
          .showSuccess(title: widget.status == 'Register' ? 'Đăng ký thành công' : 'Đổi mật khẩu thành công');
    }
  }

  @override
  Widget build(BuildContext context) {
    const defaultPinTheme = PinTheme(
      width: 54,
      height: 54,
      textStyle: TextStyle(fontSize: 18.0),
      decoration: BoxDecoration(),
    );

    return Scaffold(
      appBar: appBar(title: 'Xác nhận OTP', context: context),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: AppThemes.gap),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                'Kiểm tra email đã đăng ký của bạn. Chúng tôi đã gửi cho bạn mã PIN ******',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppThemes.hintColor),
              ),
              SizedBox(
                height: AppThemes.gap * 2,
              ),
              Pinput(
                length: 6,
                pinAnimationType: PinAnimationType.slide,
                controller: controller,
                defaultPinTheme: defaultPinTheme,
                submittedPinTheme: defaultPinTheme.copyWith(
                  textStyle: TextStyle(color: AppThemes.primaryColor, fontSize: 18.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 3, color: AppThemes.primaryColor),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.05999999865889549),
                        offset: Offset(0, 3),
                        blurRadius: 16,
                      )
                    ],
                  ),
                ),
                showCursor: true,
                cursor: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppThemes.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
                preFilledWidget: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppThemes.lightColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: AppThemes.gap * 4,
              ),
              ElevatedButton(onPressed: handleSubmit, child: Text('Xác nhận')),
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
