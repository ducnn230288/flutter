import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';
import '/widgets/index.dart';

class UserDetails extends StatefulWidget {
  final String id;

  const UserDetails({super.key, required this.id});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Chi tiết tài khoản'),
      body: BlocBuilder<BlocC<MUser>, BlocS<MUser>>(
        builder: (context, state) {
          return _listFormItem.isEmpty ? const Center(child: WLoading()) : ListView(children: [
            for (var i = 0; i < _listFormItem.length; i++) DataDetails(data: _listFormItem[i]),
          ]);
        },
      ),
    );
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  // final bool _isCustomerUser = GoRouter.of(rootNavigatorKey.currentState!.context).location.contains(CRoute.customerUser);
  List<MFormItem> _listFormItem = [];
  Future<void> _init() async {
    var result = await RepositoryProvider.of<Api>(context).user.details(id: widget.id);
    if (result != null) {
      final MUser data = MUser.fromJson(result.data);
      // final bool isFarmer = data.profileType == 'FARMER';
      _listFormItem = [
        MFormItem(label: 'Thông tin chung', dataType: DataType.separation),
        MFormItem(label: 'Họ và tên', value: data.name),
        MFormItem(label: 'Email', value: data.userName),
        MFormItem(label: 'Loại tài khoản', value: CPref.statusTitle(data.profileType), bold: true),
        MFormItem(label: 'Giới tính', value: CPref.statusTitle(data.gender)),
        if (!Role.isFarmer)
          MFormItem(label: 'Số điện thoại', value: Convert.phoneNumber(data.phoneNumber), dataType: DataType.phone),
        if (!Role.isFarmer)
          MFormItem(label: 'Ngày hoạt động cuối', value: Convert.dateTime(data.lastActivityDate)),
        // if (!Role.isFarmer && _isCustomerUser) ...[
        //   MFormItem(label: 'Thống kê tài khoản', dataType: DataType.separation),
        //   MFormItem(
        //     label: isFarmer ? 'Số đơn đã nhận' : 'Số phòng khám',
        //     value: isFarmer ? data.profileFarmer.totalOrderReceivedCount.toString() : data.totalClinic.toString(),
        //   ),
        //   MFormItem(
        //     label: isFarmer ? 'Số đơn đã hoàn thành' : 'Tổng số đơn hàng',
        //     value: isFarmer ? data.profileFarmer.totalOrderCompletedCount.toString() : data.totalOrder.toString(),
        //   ),
        // ],
        MFormItem(label: 'Thao tác', dataType: DataType.separation),
        // if (!Role.isFarmer &&  isFarmer)
        //   MFormItem(
        //     child: buttonRow(
        //       label: 'Hồ sơ Farmer',
        //       width: 113,
        //       color: CColor.purple,
        //       title: 'Xem hồ sơ',
        //       icon: Icons.badge,
        //       onPressed: () {
        //         if (data.profileFarmer.provinceCode != 0) {
        //           context.pushNamed(
        //             CRoute.farmerProfile,
        //             queryParameters: {'title': 'Hồ sơ Farmer'},
        //             extra: data.profileFarmer,
        //           );
        //         } else {
        //           UDialog().showError(text: 'Farmer chưa cập nhật hồ sơ');
        //         }
        //       },
        //     ),
        //   ),
        // if (!Role.isFarmer)
        //   MFormItem(
        //     child: buttonRow(
        //       label: 'Ví điện tử',
        //       width: 93,
        //       color: CColor.warning.shade600,
        //       title: 'Xem ví',
        //       icon: Icons.wallet,
        //       onPressed: () => context.pushNamed(
        //         CRoute.wallet,
        //         queryParameters: {'title': 'Ví của ${data.name}', 'id': data.id},
        //       ),
        //     ),
        //   ),
        if (!Role.isFarmer)
          MFormItem(
            child: buttonRow(
              label: 'Kích hoạt',
              width: data.isLockedOut ? 115 : 85,
              color: data.isLockedOut ? CColor.green : CColor.danger,
              title: data.isLockedOut ? 'Mở khóa' : 'Khóa',
              icon: data.isLockedOut ? Icons.lock_open : Icons.lock_outline,
              onPressed: () => UDialog().showConfirm(
                title: '${data.isLockedOut ? 'Mở khóa' : 'Khóa'} tài khoản',
                text: 'Bạn có chắc chắn muốn ${data.isLockedOut ? 'MỞ KHÓA' : 'KHÓA'} tài khoản này không?',
                btnOkOnPress: () {
                  context.pop();
                  context.read<BlocC<MUser>>().submit(
                    onlyApi: true,
                    submit: (_) => context.pop(),
                    api: (_, __, ___, ____) => RepositoryProvider.of<Api>(context)
                        .user
                        .action(id: data.id, action: data.isLockedOut ? 'unlock' : 'lock'));
                }),
            ),
          ),
      ];
      context.read<BlocC<MUser>>().setList(list: _listFormItem);
    }
  }
}
