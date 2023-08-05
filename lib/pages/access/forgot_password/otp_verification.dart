import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/utils/index.dart';

class OTPVerificationPage extends StatefulWidget {
  final String email;

  const OTPVerificationPage({Key? key, required this.email}) : super(key: key);

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'pages.login.otp_verification.Confirm OTP'.tr()),
      body: ListView(
        padding: const EdgeInsets.all(CSpace.superLarge),
        children: [
          Text('Để xác nhận email là của bạn, nhập mã gồm 6 chữ số vừa được gửi đến email:\n${widget.email}'),
          const VSpacer(40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: CSpace.large),
            child: Pinput(
              length: 6,
              pinAnimationType: PinAnimationType.slide,
              controller: _controller,
              defaultPinTheme: _defaultPinTheme,
              onCompleted: (text) {
                checkToken();
              },
            ),
          ),
          const VSpacer(44),
          ElevatedButton(onPressed: checkToken, child: Text('pages.login.otp_verification.Confirm'.tr())),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => context.read<BlocC>().submit(
                    onlyApi: true,
                    api: (_, __, ___, ____) =>
                        RepositoryProvider.of<Api>(context).auth.forgotPassword(email: widget.email)),
                child: const Text('Gửi lại mã xác nhận', style: TextStyle(fontSize: CFontSize.body)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  final TextEditingController _controller = TextEditingController();
  final double _size = (CSpace.width - 4 * CSpace.large - 5 * CSpace.medium) / 6;
  late final PinTheme _defaultPinTheme;

  @override
  void initState() {
    _defaultPinTheme = PinTheme(
      height: _size,
      width: _size,
      textStyle: TextStyle(color: CColor.primary, fontSize: CFontSize.title2, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Color.fromRGBO(17, 12, 34, 0.12), offset: Offset(0, 2), blurRadius: 1)],
      ),
    );
    super.initState();
  }

  void checkToken() async {
    if (_controller.text.length == 6) {
      context.read<BlocC>().submit(
          onlyApi: true,
          api: (_, __, ___, ____) =>
              RepositoryProvider.of<Api>(context).auth.verifyForgotPassword(resetPasswordToken: _controller.text),
          submit: (data) =>
              context.pushNamed(CRoute.resetPassword, queryParams: {'resetPasswordToken': _controller.text}));
    }
  }
}
