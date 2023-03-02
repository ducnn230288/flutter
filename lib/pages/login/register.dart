import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/constants/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/widgets/index.dart';
import '../../utils/index.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  // handleSubmit() async {
  //   context.pushNamed(RoutesName.otpVerification, extra: 'Register');
  // }

  @override
  Widget build(BuildContext context) {
    AppFormCubit cubit = context.read<AppFormCubit>();
    AppAuthCubit auth = context.read<AppAuthCubit>();

    final List<ModelFormItem> listFormItem = [
      ModelFormItem(name: 'name', label: 'Họ và tên', icon: 'assets/form/full-name.svg'),
      ModelFormItem(
        name: 'email',
        label: 'Địa chỉ email',
        icon: 'assets/form/mail.svg',
      ),
      ModelFormItem(type: "select", name: 'gender', label: 'Giới tính', icon: 'assets/form/gender.svg', items: [
        ModelOption(label: 'Nam', value: 'MALE'),
        ModelOption(label: 'Nữ', value: 'FEMALE'),
      ]),
      ModelFormItem(name: 'password', label: 'Mật khẩu', icon: 'assets/form/password.svg', password: true),
      ModelFormItem(
          name: 'confirmPassword', label: 'Nhập lại mật khẩu', icon: 'assets/form/password.svg', password: true),
      ModelFormItem(
          type: "select",
          name: 'role',
          label: 'Loại tài khoản',
          icon: 'assets/form/type-account.svg',
          items: [
            ModelOption(label: 'Order Side', value: 'ORDER_SIDE'),
            ModelOption(label: 'Farmer Side', value: 'FARMER_SIDE'),
          ]),
      ModelFormItem(
          type: "select",
          name: 'professionalDegree',
          label: 'Bằng cấp chuyên môn',
          icon: 'assets/form/degree.svg',
          show: false,
          items: [
            ModelOption(label: 'Bằng điều dưỡng', value: 'value1'),
          ])
    ];
    onChangeType(String text) async {
      if (text == 'FARMER_SIDE' && !listFormItem[6].show) {
        listFormItem[6].show = true;
        cubit.setList(list: listFormItem);
      } else if (text != 'FARMER_SIDE' && listFormItem[6].show) {
        listFormItem[6].show = false;
        cubit.saved(name: 'degree', value: null);
        cubit.setList(list: listFormItem);
      }
    }

    listFormItem[5].onChange = onChangeType;

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
                    BlocConsumer<AppFormCubit, AppFormState>(
                      listenWhen: (context, state) => state.status == AppStatus.success,
                      listener: (context, state) => Navigator.pop(context),
                      builder: (context, state) => ElevatedButton(
                          onPressed: () => cubit.submit(
                              context: context,
                              auth: auth,
                              api: (value, logout, page, size, sort) =>
                                  RepositoryProvider.of<Api>(context).register(body: value)),
                          child: const Text('Đăng ký')),
                    ),
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
