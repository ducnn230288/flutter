import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';

class CreateUser extends StatefulWidget {
  final MUser? data;
  final FormType formType;

  const CreateUser({super.key, this.data, required this.formType});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {

  String _title = '';
  String _titleButton = '';
  @override
  Widget build(BuildContext context) {
    switch (widget.formType) {
      case FormType.create:
        _title = 'Tạo mới tài khoản';
        _titleButton = 'Tạo mới';
        break;
      case FormType.edit:
        _title = 'Chỉnh sửa tài khoản';
        _titleButton = 'Lưu thay đổi';
        break;
      case FormType.password:
        _title = 'Đổi mật khẩu';
        _titleButton = 'Lưu thay đổi';
        break;
    }
    return Scaffold(
      appBar: appBar(title: _title),
      body: ListView(
        padding: const EdgeInsets.all(CSpace.xl3),
        children: [
          BlocBuilder<BlocC<MUser>, BlocS<MUser>>(
            builder: (context, state) {
              return _listFormItem.isEmpty ? const Center(child: WLoading()) : WForm<MUser>(list: _listFormItem);
            }
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(CSpace.xl3),
          child: ElevatedButton(onPressed: _onSubmit, child: Text(_titleButton)),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () { _init(); });
  }

  List<MFormItem> _listFormItem = [];
  Future<void> _init() async {
    final cubit = context.read<BlocC<MUser>>();
    MUser? data = widget.data;
    final bool isInternalUser = GoRouterState.of(context).uri.toString().contains(CRoute.internalUser);
    if (widget.formType == FormType.edit) {
      var result = await RepositoryProvider.of<Api>(context).user.details(id: widget.data!.id);
      if (result != null) data = MUser.fromJson(result.data);
    }

    _listFormItem = [
      MFormItem(
        label: 'Thông tin đăng ký',
        type: EFormItemType.title,
        show: widget.formType == FormType.create || widget.formType == FormType.edit),
      MFormItem(name: 'email', label: 'Email', show: widget.formType == FormType.create),
      MFormItem(
        name: 'password',
        label: 'Mật khẩu',
        password: true,
        show: widget.formType == FormType.create || widget.formType == FormType.password,
        onValidator: (value, listController) {
          if (value != null && listController['confirmPassword']!.text != '' && value != listController['confirmPassword']!.text) {
            return 'Mật khẩu không khớp';
          }
          return null;
        }
      ),
      MFormItem(
        name: 'confirmPassword',
        label: 'Xác nhận mật khẩu',
        password: true,
        show: widget.formType == FormType.create || widget.formType == FormType.password,
        onValidator: (value, listController) {
          if (value != null && listController['password']!.text != '' && value != listController['password']!.text) {
            return 'Mật khẩu không khớp';
          }
          return null;
        }
      ),
      MFormItem(
        type: EFormItemType.select,
        name: 'roleListCode',
        hintText: 'Chọn',
        value: data != null ? CPref.statusTitle(data.roleListCode[0]) : '',
        code: data != null ? data.roleListCode[0] : '',
        label: 'Loại tài khoản',
        items: [
          isInternalUser
            ? MOption(label: 'Chăm sóc khách hàng', value: 'CSKH')
            : MOption(label: 'Order Side', value: 'ORDERER'),
          isInternalUser ? MOption(label: 'Kế toán', value: 'KT') : MOption(label: 'Farmer Side', value: 'FARMER'),
        ],
        show: widget.formType == FormType.create || widget.formType == FormType.edit),
      MFormItem(
        label: 'Thông tin cá nhân',
        type: EFormItemType.title,
        show: widget.formType == FormType.create || widget.formType == FormType.edit),
      MFormItem(
        name: 'name',
        label: 'Họ và tên',
        value: data?.name,
        show: widget.formType == FormType.create || widget.formType == FormType.edit),
      MFormItem(
        type: EFormItemType.select,
        name: 'gender',
        label: 'Giới tính',
        hintText: 'Chọn',
        items: [MOption(label: 'Nam', value: 'MALE'), MOption(label: 'Nữ', value: 'FEMALE')],
        value: data?.gender != null ? CPref.statusTitle(data!.gender) : '',
        code: data?.gender,
        show: widget.formType == FormType.create || widget.formType == FormType.edit),
      MFormItem(
        name: 'phoneNumber',
        label: 'Số điện thoại',
        keyBoard: EFormItemKeyBoard.phone,
        formatNumberType: FormatNumberType.normal,
        value: data?.phoneNumber,
        show: widget.formType == FormType.create || widget.formType == FormType.edit),
    ];

    cubit.setList(list: _listFormItem);
  }

  void _onSubmit() async {
    final cubit = context.read<BlocC<MUser>>();
    switch (widget.formType) {
      case FormType.create:
        cubit.submit(
          api: (value, page, size, sort) {
            Map<String, dynamic> newValue = Map.from(value);
            newValue['isLockedOut'] = true;
            newValue['isActive'] = true;
            newValue['isRevokedToken'] = true;
            newValue['roleListCode'] = [newValue['roleListCode']];
            newValue.remove('confirmPassword');
            return RepositoryProvider.of<Api>(context).user.register(body: newValue);
          },
          submit: (data) => context.pop(true),
        );
        break;
      case FormType.edit:
        cubit.submit(
          api: (value, page, size, sort) {
            Map<String, dynamic> newValue = Map.from(value);
            newValue['roleListCode'] = [newValue['roleListCode']];
            return RepositoryProvider.of<Api>(context).user.edit(id: widget.data!.id, body: newValue);
          },
          submit: (data) => context.pop());
        break;
      case FormType.password:
        cubit.submit(
          api: (value, page, size, sort) {
            Map<String, dynamic> newValue = Map.from(value);
            newValue.remove('confirmPassword');
            return RepositoryProvider.of<Api>(context).user.setPassword(id: widget.data!.id, body: newValue);
          },
          submit: (data) => context.pop(),
        );
        break;
    }
  }
}

enum FormType { create, edit, password }
