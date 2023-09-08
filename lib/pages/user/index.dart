import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/pages/index.dart';
import '/utils/index.dart';
import '/widgets/index.dart';

part '_end_drawer.dart';
part '_popup.dart';

class User extends StatefulWidget {
  const User({Key? key}) : super(key: key);

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: 'Tài khoản ${isInternalUser ? 'nội bộ' : 'người dùng'}',
        actions: [
          Builder(builder: (context) {
            return GestureDetector(
              child: Container(
                height: 40,
                width: 40,
                color: Colors.transparent,
                child: const Icon(Icons.filter_alt_outlined, color: Colors.white),
              ),
              onTap: () => Scaffold.of(context).openEndDrawer(),
            );
          }),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: CSpace.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextSearch<MUser>(
                  margin: const EdgeInsets.symmetric(horizontal: CSpace.large),
                  api: (filter, page, size, sort) => user.get(filter: filter, page: page, size: size),
                  format: MUser.fromJson,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: CSpace.mediumSmall, horizontal: CSpace.large),
                  child: WidgetFilter<MUser>(
                    filter: [
                      MFilter(label: 'Tất cả', value: ''),
                      isInternalUser
                          ? MFilter(label: 'CSKH', value: 'CSKH')
                          : MFilter(label: 'Order Side', value: 'ORDERER'),
                      isInternalUser
                          ? MFilter(label: 'Kế toán', value: 'KT')
                          : MFilter(label: 'Farmer Side', value: 'FARMER'),
                    ],
                    submit: () => context.read<BlocC<MUser>>().submit(
                        getData: true,
                        notification: false,
                        api: (filter, page, size, sort) =>
                            RepositoryProvider.of<Api>(context).user.get(filter: filter, page: page, size: size),
                        format: MUser.fromJson),
                    keyValue: 'roleCode',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: CSpace.large),
                  child: totalElementTitle<MUser>(suffix: 'tài khoản'),
                )
              ],
            ),
          ),
          Expanded(
            child: WList<MUser>(
              apiId: (item) => user.details(id: item.id),
              item: (data, int index) {
                final cubit = context.read<BlocC<MUser>>();
                final content = cubit.state.data.content.cast<MUser>().toList();
                String? createdOnDate = DateTime.tryParse(content[index].createdOnDate) != null
                    ? Convert.date(content[index].createdOnDate)
                    : null;
                if (index > 0 &&
                    DateTime.tryParse(content[index].createdOnDate) != null &&
                    DateTime.tryParse(content[index - 1].createdOnDate) != null) {
                  final DateTime current = DateTime.parse(content[index].createdOnDate);
                  final DateTime before = DateTime.parse(content[index - 1].createdOnDate);
                  Duration timeDifference = before.difference(current);
                  if (timeDifference.isNegative) {
                    timeDifference = timeDifference.abs();
                  }
                  if (timeDifference.inDays > 0 || (timeDifference.inHours < 24 && current.day < before.day)) {
                    createdOnDate = Convert.date(current.toIso8601String());
                  } else {
                    createdOnDate = null;
                  }
                }
                const double widthSpace = 35;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (index == 0) const VSpacer(CSpace.large),
                    if (createdOnDate != null)
                      Padding(
                        padding: const EdgeInsets.only(left: CSpace.large, bottom: CSpace.mediumSmall),
                        child: Text(
                          createdOnDate,
                          style: TextStyle(fontSize: CFontSize.footnote, color: CColor.black.shade300),
                        ),
                      ),
                    SwipeActionCell(
                      key: ValueKey(data.id),
                      trailingActions: !isInternalUser
                          ? [
                              const SwipeAction(widthSpace: 20, color: Colors.transparent),
                              SwipeAction(
                                widthSpace: widthSpace,
                                content: button(child: Icon(Icons.key, color: CColor.warning)),
                                color: Colors.transparent,
                                onTap: (handler) {
                                  context.pushNamed(
                                    CRoute.createCustomerUser,
                                    queryParams: {'formType': FormType.password.name, 'data': jsonEncode(data)},
                                  );
                                },
                              ),
                              SwipeAction(
                                widthSpace: widthSpace,
                                content: button(child: Icon(Icons.edit_square, color: CColor.primary)),
                                color: Colors.transparent,
                                onTap: (handler) {
                                  context.pushNamed(
                                    CRoute.createCustomerUser,
                                    queryParams: {'formType': FormType.edit.name, 'data': jsonEncode(data)},
                                  );
                                },
                              ),
                              SwipeAction(
                                widthSpace: widthSpace,
                                content: button(child: Icon(Icons.delete_forever_outlined, color: CColor.danger)),
                                color: Colors.transparent,
                                onTap: (handler) {
                                  UDialog().showConfirm(
                                    title: 'Xác nhận trước khi xoá',
                                    text: 'Thao tác này sẽ làm mất đi dữ liệu của bạn. Bạn có chắc chắn thực hiện?',
                                    btnOkOnPress: () async {
                                      context.read<BlocC<MUser>>().submit(
                                            onlyApi: true,
                                            submit: (_) {
                                              context.pop();
                                              context.read<BlocC<MUser>>().refreshPage(
                                                    index: index,
                                                    apiId: user.details(id: data.id),
                                                    format: MUser.fromJson,
                                                  );
                                            },
                                            api: (_, __, ___, ____) => user.delete(id: data.id),
                                          );
                                    },
                                  );
                                },
                              ),
                            ]
                          : [],
                      child: Container(
                        padding: const EdgeInsets.all(CSpace.large),
                        margin: const EdgeInsets.only(left: 2.5 * CSpace.superLarge, right: CSpace.large),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(CRadius.basic),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isInternalUser)
                              Container(
                                height: 6,
                                width: 6,
                                margin: const EdgeInsets.only(top: 5, right: CSpace.medium),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: data.isEmailVerified ? CColor.danger : isNotActiveColor,
                                ),
                              ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                '$index: ${data.name}  ',
                                                style: const TextStyle(fontWeight: FontWeight.w600),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (data.isLockedOut)
                                              Padding(
                                                padding: const EdgeInsets.only(right: 5),
                                                child: Icon(Icons.lock, color: CColor.danger, size: CFontSize.subhead),
                                              ),
                                          ],
                                        ),
                                      ),
                                      if (!isInternalUser) active(data)
                                    ],
                                  ),
                                  const VSpacer(CSpace.small),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: CFontSize.callOut,
                                          child: FittedBox(
                                            child: Text(
                                              data.userName,
                                              style: TextStyle(
                                                color: CColor.black.shade300,
                                                fontSize: CFontSize.footnote,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: isInternalUser ? 60 : 75,
                                        child: Text(
                                          CPref.statusTitle(data.roleListCode[0]),
                                          style: TextStyle(color: CColor.primary, fontSize: CFontSize.footnote),
                                          textAlign: TextAlign.right,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (isInternalUser)
                              Padding(
                                padding: const EdgeInsets.only(left: 8, top: 8.0),
                                child: _PopUpItem(ctx: context, data: data, index: index),
                              )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
              onTap: (data) => context.pushNamed(
                isInternalUser ? CRoute.internalUserDetails : CRoute.customerUserDetails,
                queryParams: {'id': data.id, 'title': data.name},
              ),
              separator: const VSpacer(CSpace.medium),
              format: MUser.fromJson,
              api: (filter, page, size, sort) => user.get(filter: filter, page: page, size: size),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CColor.danger,
        onPressed: () => context.pushNamed(
          isInternalUser ? CRoute.createInternalUser : CRoute.createCustomerUser,
          queryParams: {'formType': FormType.create.name},
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      endDrawer: _EndDrawer(cubit: context.read<BlocC<MUser>>()),
    );
  }

  late final user = RepositoryProvider.of<Api>(context).user;
  final Color isNotActiveColor = CColor.black.shade200;
  final bool isInternalUser =
      GoRouter.of(rootNavigatorKey.currentState!.context).location.contains(CRoute.internalUser);

  void getData() => context.read<BlocC<MUser>>().submit(
      getData: true,
      api: (filter, page, size, sort) => user.get(filter: filter, page: page, size: size),
      format: MUser.fromJson);

  Widget active(MUser data) {
    const double size = 17;
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Container(
          height: size,
          padding: const EdgeInsets.only(left: 6, right: 20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(size / 2), color: CColor.black.shade50),
          // alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data.isEmailVerified ? 'Đã xác thực' : 'Chưa xác thực',
                style: TextStyle(fontSize: 9, color: CColor.black.shade300),
              ),
            ],
          ),
        ),
        Container(
          height: size,
          width: size,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: data.isEmailVerified ? CColor.danger : isNotActiveColor),
        ),
      ],
    );
  }

  Widget button({required Widget child}) => Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: CColor.black.shade300.withOpacity(0.4), offset: const Offset(1, 1), blurRadius: 4)
          ],
        ),
        child: child,
      );
}
