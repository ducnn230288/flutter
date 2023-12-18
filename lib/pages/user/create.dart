import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';

class CreateUser extends StatelessWidget {
  final MUser? data;
  final FormType formType;

  const CreateUser({Key? key, this.data, required this.formType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BlocC<MUser>>();
    final bool isInternalUser = GoRouter.of(context).location.contains(CRoute.internalUser);
    List<MFormItem> listFormItem = [
      MFormItem(label: 'Thông tin đăng ký', type: EFormItemType.title),
      MFormItem(name: 'email', label: 'Email'),
      MFormItem(name: 'passwordS', label: 'Mật khẩu', password: true),
      MFormItem(name: 'confirmPassword', label: 'Xác nhận mật khẩu', password: true),
      MFormItem(
        type: EFormItemType.select,
        name: 'roleListCode',
        hintText: 'Chọn',
        value: CPref.statusTitle(data?.roleListCode[0] ?? ''),
        code: data?.roleListCode[0] ?? '',
        label: 'Loại tài khoản',
        items: [
          isInternalUser
              ? MOption(label: 'Chăm sóc khách hàng', value: 'CSKH')
              : MOption(label: 'Order Side', value: 'ORDERER'),
          isInternalUser ? MOption(label: 'Kế toán', value: 'KT') : MOption(label: 'Farmer Side', value: 'FARMER'),
        ],
      ),
      MFormItem(label: 'Thông tin cá nhân', type: EFormItemType.title),
      MFormItem(name: 'name', label: 'Họ và tên', value: data?.name ?? ''),
      MFormItem(
        type: EFormItemType.select,
        name: 'gender',
        label: 'Giới tính',
        hintText: 'Chọn',
        items: [MOption(label: 'Nam', value: 'MALE'), MOption(label: 'Nữ', value: 'FEMALE')],
        value: CPref.statusTitle(data?.gender ?? ''),
        code: data?.gender ?? '',
      ),
      MFormItem(
        name: 'phoneNumber',
        label: 'Số điện thoại',
        keyBoard: EFormItemKeyBoard.number,
        formatNumberType: FormatNumberType.normal,
        value: data?.phoneNumber ?? '',
      ),
    ];

    String title = '';
    String titleButton = '';
    switch (formType) {
      case FormType.create:
        title = 'Tạo mới tài khoản';
        titleButton = 'Tạo mới';
        break;
      case FormType.edit:
        title = 'Chỉnh sửa tài khoản';
        listFormItem.removeAt(3);
        listFormItem.removeAt(2);
        listFormItem.removeAt(1);
        titleButton = 'Lưu thay đổi';
        break;
      case FormType.password:
        title = 'Đổi mật khẩu';
        listFormItem = [listFormItem[2], listFormItem[3]];
        titleButton = 'Lưu thay đổi';
        break;
    }
    return Scaffold(
      appBar: appBar(title: title),
      body: ListView(
        padding: const EdgeInsets.all(CSpace.large),
        children: [
          WForm<MUser>(list: listFormItem),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(CSpace.large),
          child: ElevatedButton(
              onPressed: () {
                final value = context.read<BlocC<MUser>>().state.value;
                switch (formType) {
                  case FormType.create:
                    cubit.submit(
                      showDialog: value['passwordS'] == value['confirmPassword'],
                      api: (value, page, size, sort) {
                        Map<String, dynamic> newValue = Map.from(value);
                        if (newValue['passwordS'] != newValue['confirmPassword']) {
                          UDialog().showError(text: 'Nhập lại mật khẩu sai');
                          return null;
                        }
                        newValue['password'] = newValue['passwordS'];
                        newValue['isLockedOut'] = true;
                        newValue['isActive'] = true;
                        newValue['isRevokedToken'] = true;
                        newValue['roleListCode'] = [newValue['roleListCode']];
                        newValue.remove('passwordS');
                        newValue.remove('confirmPassword');
                        return RepositoryProvider.of<Api>(context).user.register(body: newValue);
                      },
                      submit: (data) => context.pop(true),
                    );
                    break;
                  case FormType.edit:
                    title = 'Chỉnh sửa tài khoản';
                    cubit.submit(
                        api: (value, page, size, sort) {
                          Map<String, dynamic> newValue = Map.from(value);
                          newValue['roleListCode'] = [newValue['roleListCode']];
                          return RepositoryProvider.of<Api>(context).user.edit(id: data!.id, body: newValue);
                        },
                        submit: (data) => context.pop());
                    break;
                  case FormType.password:
                    title = 'Đổi mật khẩu';
                    cubit.submit(
                      showDialog: value['passwordS'] == value['confirmPassword'],
                      api: (value, page, size, sort) {
                        Map<String, dynamic> newValue = Map.from(value);
                        if (newValue['passwordS'] != newValue['confirmPassword']) {
                          UDialog().showError(text: 'Nhập lại mật khẩu sai');
                          return null;
                        }
                        newValue['password'] = newValue['passwordS'];
                        newValue.remove('passwordS');
                        newValue.remove('confirmPassword');
                        return RepositoryProvider.of<Api>(context).user.setPassword(id: data!.id, body: newValue);
                      },
                      submit: (data) => context.pop(),
                    );
                    break;
                }
              },
              child: Text(titleButton)),
        ),
      ),
    );
  }
}

enum FormType { create, edit, password }
