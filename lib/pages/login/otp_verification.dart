import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '/constants/index.dart';
import '/utils/index.dart';
import '/widgets/index.dart';

class OTPVerificationPage extends StatelessWidget {
  final Object? extra;
  const OTPVerificationPage({Key? key, required this.extra}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    handleSubmit() async {
      if (controller.value.text.length == 6) {
        UDialog().showSuccess(
            title: extra == 'Register'
                ? 'pages.login.otp_verification.Sign Up Success'.tr()
                : 'pages.login.otp_verification.Change password successfully'.tr(),
            onDismiss: (context) {
              if (extra == 'Register') {
                GoRouter.of(context).pop();
                GoRouter.of(context).pop();
              } else {
                GoRouter.of(context).pop();
              }
            });
      }
    }

    const defaultPinTheme = PinTheme(
      width: 54,
      height: 54,
      textStyle: TextStyle(fontSize: 18.0),
      decoration: BoxDecoration(),
    );

    return Scaffold(
      appBar: appBar(title: 'pages.login.otp_verification.Confirm OTP'.tr()),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: CSpace.large),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                '${'pages.login.otp_verification.Check your registered email'.tr()} ******',
                textAlign: TextAlign.center,
                style: TextStyle(color: CColor.black.shade300),
              ),
              const SizedBox(
                height: CSpace.large * 2,
              ),
              Pinput(
                length: 6,
                pinAnimationType: PinAnimationType.slide,
                controller: controller,
                defaultPinTheme: defaultPinTheme,
                submittedPinTheme: defaultPinTheme.copyWith(
                  textStyle: TextStyle(color: CColor.primary, fontSize: 18.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 3, color: CColor.primary),
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
                        color: CColor.primary,
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
                        color: CColor.black.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: CSpace.large * 4,
              ),
              ElevatedButton(onPressed: handleSubmit, child: Text('pages.login.otp_verification.Confirm'.tr())),
              const SizedBox(
                height: CSpace.large,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
