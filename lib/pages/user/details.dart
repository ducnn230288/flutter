import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';

class UserDetails extends StatefulWidget {
  final String id;

  const UserDetails({Key? key, required this.id}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Chi tiết tài khoản'),
      body: BlocBuilder<BlocC, BlocS>(
        builder: (context, state) {
          if (state.status == AppStatus.success) {
            final MUser data = state.value['account'];
            final bool isFarmer = data.profileType == 'FARMER';
            final List<MFormItem> formItems = [
              MFormItem(label: 'Thông tin chung', dataType: DataType.separation),
              MFormItem(label: 'Họ và tên', value: data.name),
              MFormItem(label: 'Email', value: data.userName),
              MFormItem(label: 'Loại tài khoản', value: CPref.statusTitle(data.profileType), bold: true),
              MFormItem(label: 'Giới tính', value: CPref.statusTitle(data.gender)),
              MFormItem(label: 'Số điện thoại', value: Convert.phoneNumber(data.phoneNumber), dataType: DataType.phone),
              MFormItem(label: 'Ngày hoạt động cuối', value: Convert.dateTime(data.lastActivityDate)),
              // if (isCustomerUser) ...[
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
              // if (isFarmer)
              // MFormItem(
              //   child: button(
              //     label: 'Hồ sơ Farmer',
              //     width: 113,
              //     color: const Color(0xFFA855F7),
              //     title: 'Xem hồ sơ',
              //     icon: Icons.badge,
              //     onPressed: ()=> context.pushNamed(
              //       CRoute.farmerProfile,
              //       queryParams: {
              //         'data': jsonEncode(data.profileFarmer),
              //         'title': 'Hồ sơ Farmer',
              //       },
              //     ),
              //   ),
              // ),
              // MFormItem(
              //   child: button(
              //     label: 'Ví điện tử',
              //     width: 93,
              //     color: const Color(0xFFF59E0B),
              //     title: 'Xem ví',
              //     icon: Icons.wallet,
              //     onPressed: () => context.pushNamed(
              //       CRoute.wallet,
              //       queryParams: {'title': 'Ví của ${data.name}', 'id': data.id},
              //     ),
              //   ),
              // ),
              MFormItem(
                child: button(
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
                        context.read<BlocC>().submit(
                            onlyApi: true,
                            submit: (_) => context.pop(),
                            api: (_, __, ___, ____) => RepositoryProvider.of<Api>(context)
                                .user
                                .action(id: data.id, action: data.isLockedOut ? 'unlock' : 'lock'));
                      }),
                ),
              ),
            ];
            return WList<dynamic>(
                items: formItems, item: (data, index) => DataDetails(data: data), status: AppStatus.success);
          }
          return Center(child: WLoading());
        },
      ),
    );
  }

  final bool isCustomerUser =
      GoRouter.of(rootNavigatorKey.currentState!.context).location.contains(CRoute.customerUser);

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    var result = await RepositoryProvider.of<Api>(context).user.details(id: widget.id);
    if (result != null) {
      context.read<BlocC>().setValue(value: {'account': MUser.fromJson(result.data)}, status: AppStatus.success);
    }
  }

  Widget button({
    required String label,
    required String title,
    required IconData icon,
    required Function() onPressed,
    required Color color,
    required double width,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: CSpace.small),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(color: CColor.black.shade300))),
          SizedBox(
            width: width,
            height: CHeight.superSmall,
            child: ElevatedButton(
              style: CStyle.buttonFill(backgroundColor: color),
              onPressed: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: CFontSize.title3),
                  const HSpacer(CSpace.small),
                  Text(title)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
