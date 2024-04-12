import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';
import '/widgets/index.dart';
import 'create.dart';

part '_end_drawer.dart';
part '_popup.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> with TickerProviderStateMixin {

  double _height = 123.0;
  late final _user = RepositoryProvider.of<Api>(context).user;
  @override
  Widget build(BuildContext context) {
    final bool isInternalUser = GoRouterState.of(context).uri.toString().contains(CRoute.internalUser);

    return Scaffold(
      appBar: appBar(
        title: 'Tài khoản ${isInternalUser ? 'nội bộ' : 'người dùng'}',
        actions: [
          Builder(builder: (context) {
            return BlocBuilder<BlocC<MUser>, BlocS<MUser>>(
              builder: (context, state) {
                return InkWell(
                  key: const ValueKey('filter'),
                  splashColor: CColor.primary.shade100,
                  child: Container(
                    height: 40,
                    width: 40,
                    color: Colors.transparent,
                    child: Icon(
                        (state.value['dateRange'] != null ||
                                state.value['isLockedOut'] != null ||
                                state.value['isEmailVerified'] != null)
                            ? Icons.filter_alt
                            : Icons.filter_alt_outlined,
                        color: Colors.white),
                  ),
                  onTap: () => Scaffold.of(context).openEndDrawer(),
                );
              },
            );
          }),
        ],
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: _height,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: CSpace.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextSearch<MUser>(
                  margin: const EdgeInsets.symmetric(horizontal: CSpace.xl3),
                  api: (filter, page, size, sort) => _user.get(filter: filter, page: page, size: size),
                  format: MUser.fromJson,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: CSpace.base, horizontal: CSpace.xl3),
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
                    api: (filter, page, size, sort) =>
                        RepositoryProvider.of<Api>(context).user.get(filter: filter, page: page, size: size),
                    keyValue: 'roleCode',
                    format: MUser.fromJson,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: CSpace.xl3),
                  child: totalElementTitle<MUser>(suffix: 'tài khoản'),
                ),
              ],
            ),
          ),
          Expanded(
            child: WList<MUser>(
              onScroll: (controller, number) {
                double height = controller.position.pixels < 150 || number >= 0 ? 123 : 0;
                if (height != _height && controller.position.pixels < controller.position.maxScrollExtent) {
                  setState(() => _height = height);
                }
              },
              item: (data, int index) {
                String? createdOnDate = Convert.getGroupDate(context.read<BlocC<MUser>>(), index, 'createdOnDate');
                const double widthSpace = 35;
                void refresh() {
                  context.read<BlocC<MUser>>().refreshPage(
                        index: index,
                        apiId: _user.details(id: data.id),
                        format: MUser.fromJson,
                      );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (index == 0) const VSpacer(CSpace.xl3),
                    if (createdOnDate != null)
                      Padding(
                        padding: const EdgeInsets.only(left: CSpace.xl3, bottom: CSpace.base),
                        child: Text(
                          createdOnDate,
                          style: TextStyle(fontSize: CFontSize.sm, color: CColor.black.shade300),
                        ),
                      ),
                    SwipeActionCell(
                      key: ValueKey(data.id),
                      trailingActions: !isInternalUser
                          ? [
                              const SwipeAction(widthSpace: 20, color: Colors.transparent),
                              SwipeAction(
                                widthSpace: widthSpace,
                                content: _button(child: Icon(Icons.key, color: CColor.warning)),
                                color: Colors.transparent,
                                onTap: (handler) {
                                  context.pushNamed(CRoute.createCustomerUser,
                                      queryParameters: {'formType': FormType.password.name}, extra: data);
                                },
                              ),
                              SwipeAction(
                                widthSpace: widthSpace,
                                content: _button(child: Icon(Icons.edit_square, color: CColor.primary)),
                                color: Colors.transparent,
                                onTap: (handler) async {
                                  await context.pushNamed(
                                    CRoute.createCustomerUser,
                                    queryParameters: {'formType': FormType.edit.name},
                                    extra: data,
                                  );
                                  refresh();
                                },
                              ),
                              SwipeAction(
                                widthSpace: widthSpace,
                                content: _button(child: Icon(Icons.delete_forever_outlined, color: CColor.danger)),
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
                                              refresh();
                                            },
                                            api: (_, __, ___, ____) => _user.delete(id: data.id),
                                          );
                                    },
                                  );
                                },
                              ),
                            ]
                          : [],
                      child: Container(
                        padding: const EdgeInsets.all(CSpace.xl3),
                        margin: const EdgeInsets.only(left: 2.5 * CSpace.xl5, right: CSpace.xl3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(CSpace.xs),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isInternalUser)
                              Container(
                                height: 6,
                                width: 6,
                                margin: const EdgeInsets.only(top: 5, right: CSpace.xl),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: data.isEmailVerified ? CColor.danger : CColor.black.shade200,
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
                                                '${data.name}  ',
                                                style: const TextStyle(fontWeight: FontWeight.w600),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (data.isLockedOut)
                                              Padding(
                                                padding: const EdgeInsets.only(right: 5),
                                                child: Icon(Icons.lock, color: CColor.danger, size: CFontSize.base),
                                              ),
                                          ],
                                        ),
                                      ),
                                      if (!isInternalUser) _active(data)
                                    ],
                                  ),
                                  const VSpacer(CSpace.sm),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: CFontSize.base,
                                          child: FittedBox(
                                            child: Text(
                                              data.userName,
                                              style: TextStyle(
                                                color: CColor.black.shade300,
                                                fontSize: CFontSize.sm,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: isInternalUser ? 60 : 75,
                                        child: Text(
                                          CPref.statusTitle(data.roleListCode[0]),
                                          style: TextStyle(color: CColor.primary, fontSize: CFontSize.sm),
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
                queryParameters: {'id': data.id, 'title': data.name},
              ),
              separator: const VSpacer(CSpace.sm),
              format: MUser.fromJson,
              api: (filter, page, size, sort) => _user.get(filter: filter, page: page, size: size, isEmployee: isInternalUser),
              apiId: (item) => _user.details(id: item.id),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: const ValueKey('add'),
        backgroundColor: CColor.danger,
        onPressed: () async {
          var check = await context.pushNamed(
            isInternalUser ? CRoute.createInternalUser : CRoute.createCustomerUser,
            queryParameters: {'formType': FormType.create.name},
          );
          if (check == true) {
            _getData();
          }
        },
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      endDrawer: _EndDrawer<MUser>(
        format: MUser.fromJson,
        isCustomer: isInternalUser
      ),
    );
  }



  void _getData() => context.read<BlocC<MUser>>().setPage(
      api: (filter, page, size, sort) => _user.get(filter: filter, page: page, size: size),
      format: MUser.fromJson,
      page: 1);

  Widget _active(MUser data) {
    const double size = 17;
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Container(
          height: size,
          padding: const EdgeInsets.only(left: 6, right: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size / 2), color: CColor.black.shade100.withOpacity(0.2)),
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
              BoxDecoration(shape: BoxShape.circle, color: data.isEmailVerified ? CColor.danger : CColor.black.shade200),
        ),
      ],
    );
  }

  Widget _button({required Widget child}) => Container(
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
