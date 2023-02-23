import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '/constants.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: Space.large),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                'Kiểm tra email đã đăng ký của bạn. Chúng tôi đã gửi cho bạn mã PIN ******',
                textAlign: TextAlign.center,
                style: TextStyle(color: ColorName.black.shade300),
              ),
              const SizedBox(
                height: Space.large * 2,
              ),
              Pinput(
                length: 6,
                pinAnimationType: PinAnimationType.slide,
                controller: controller,
                defaultPinTheme: defaultPinTheme,
                submittedPinTheme: defaultPinTheme.copyWith(
                  textStyle: TextStyle(color: ColorName.primary, fontSize: 18.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 3, color: ColorName.primary),
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
                        color: ColorName.primary,
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
                        color: ColorName.black.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: Space.large * 4,
              ),
              ElevatedButton(onPressed: handleSubmit, child: const Text('Xác nhận')),
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
