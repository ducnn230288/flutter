import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/constants/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/widgets/index.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  // handleSubmit() async {
  //   context.pushNamed(RoutesName.otpVerification, extra: 'Register');
  // }

  @override
  Widget build(BuildContext context) {
    AppFormCubit cubit = context.read<AppFormCubit>();

    final List<ModelFormItem> listFormItem = [
      ModelFormItem(name: 'fullname', placeholder: true, label: 'Họ và tên', icon: 'assets/form/fullname.svg'),
      ModelFormItem(
        name: 'email',
        label: 'Địa chỉ email',
        icon: 'assets/form/mail.svg',
      ),
      ModelFormItem(name: 'password', label: 'Mật khẩu', icon: 'assets/form/password.svg', password: true),
      ModelFormItem(
          name: 'confirmPassword', label: 'Nhập lại mật khẩu', icon: 'assets/form/password.svg', password: true),
      ModelFormItem(
          type: "select",
          name: 'type',
          label: 'Loại tài khoản',
          icon: 'assets/form/type-account.svg',
          items: [
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
      if (text == 'value2' && !listFormItem[5].show) {
        listFormItem[5].show = true;
        cubit.setList(list: listFormItem);
      } else if (text != 'value2' && listFormItem[5].show) {
        listFormItem[5].show = false;
        cubit.saved(name: 'degree', value: null);
        cubit.setList(list: listFormItem);
      }
    }

    listFormItem[4].onChange = onChangeType;

    return Scaffold(
      appBar: appBar(title: 'Đăng ký', context: context),
      body: SizedBox(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(
                height: Space.large,
              ),
              BlocListener<AppFormCubit, AppFormState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: Space.large),
                    child: WidgetForm(list: listFormItem)),
              ),
              const SizedBox(
                height: Space.large * 2,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: Space.large),
                child: Column(
                  children: [
                    ElevatedButton(onPressed: () => cubit.submit(context: context), child: const Text('Đăng ký')),
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
