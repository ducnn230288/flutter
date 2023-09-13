import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';

drawer() {
  BuildContext context = rootNavigatorKey.currentState!.context;
  final double widthDrawer = CSpace.width * 0.8;
  double widthImage = CSpace.width * 0.25;
  final double widthInfo = widthDrawer - widthImage - 2 * CSpace.mediumSmall;
  return Drawer(
    elevation: 20,
    width: widthDrawer,
    backgroundColor: Colors.white,
    child: SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<AuthC, AuthS>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            InkWell(
                              splashColor: CColor.primary.shade100,
                              onTap: () => context.pushNamed(CRoute.myAccountInfo),
                              child: Container(
                                width: widthDrawer,
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: widthImage,
                                      width: widthImage,
                                      child: CIcon.logo,
                                    ),
                                    state.status == AppStatus.success
                                        ? Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: CFontSize.title3,
                                                width: widthInfo,
                                                alignment: Alignment.centerLeft,
                                                child: FittedBox(
                                                  child: Text(
                                                    state.user!.name,
                                                    style: const TextStyle(
                                                        fontSize: CFontSize.title3, fontWeight: FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: CFontSize.subhead,
                                                width: widthInfo,
                                                alignment: Alignment.centerLeft,
                                                child: state.user?.userName != ''
                                                    ? FittedBox(
                                                        child: Text(
                                                          state.user!.userName,
                                                          style: TextStyle(color: CColor.black.shade300),
                                                        ),
                                                      )
                                                    : Container(),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                            state.zalo != null
                                ? InkWell(
                                    onTap: () async {
                                      await launchUrl(Uri(scheme: 'tel', path: state.zalo));
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                            width: widthDrawer,
                                            padding: const EdgeInsets.fromLTRB(
                                              CSpace.mediumSmall,
                                              CSpace.medium,
                                              CSpace.medium,
                                              CSpace.medium,
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.phone, color: Colors.black, size: 16),
                                                const Flexible(
                                                  flex: 1,
                                                  child: Text(
                                                    ' Hotline: ',
                                                    style: TextStyle(fontWeight: FontWeight.w600),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 10,
                                                  ),
                                                ),
                                                Text(Convert.phoneNumber(state.zalo!))
                                              ],
                                            )),
                                        line(color: CColor.black.shade100)
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
            BlocBuilder<AuthC, AuthS>(
              builder: (context, state) {
                return state.status == AppStatus.success
                    ? Expanded(
                        child: BlocProvider(
                          create: (context) => BlocC<DrawerData>(),
                          child: WList<DrawerData>(
                            item: (drawer, index) {
                              if (drawer.subChild!.isNotEmpty) {
                                return ExpansionTileCard(
                                  scrollSettings: () async {},
                                  title: Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: CSpace.mediumSmall),
                                      child: Text(
                                        drawer.name!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontSize: CFontSize.callOut,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                  titlePadding:
                                      const EdgeInsets.fromLTRB(0, CSpace.medium, CSpace.medium, CSpace.medium),
                                  trailing: CIcon.arrowRight,
                                  children: [
                                    line(color: CColor.black.shade100),
                                    ListView.separated(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        separatorBuilder: (_, index) {
                                          return line(color: CColor.black.shade100);
                                        },
                                        itemCount: drawer.subChild?.length ?? 0,
                                        itemBuilder: (_, index) {
                                          return InkWell(
                                            onTap: () {
                                              context.goNamed(drawer.subChild![index].urlRewrite!);
                                            },
                                            child: Container(
                                                padding: const EdgeInsets.fromLTRB(
                                                  CSpace.large,
                                                  CSpace.medium,
                                                  CSpace.medium,
                                                  CSpace.medium,
                                                ),
                                                child: Text(
                                                  drawer.subChild![index].name!,
                                                  style: const TextStyle(
                                                    fontSize: CFontSize.callOut,
                                                  ),
                                                )),
                                          );
                                        }),
                                  ],
                                );
                              }
                              return InkWell(
                                onTap: () => context.goNamed(drawer.urlRewrite!),
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.fromLTRB(
                                      CSpace.mediumSmall,
                                      CSpace.medium,
                                      CSpace.medium,
                                      CSpace.medium,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            drawer.name!,
                                            style: TextStyle(
                                              fontWeight:
                                                  drawer.subChild!.isNotEmpty ? FontWeight.w600 : FontWeight.w400,
                                              fontSize: CFontSize.callOut,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    )),
                              );
                            },
                            format: DrawerData.fromJson,
                            separator: line(color: CColor.black.shade100),
                            api: (filter, page, size, sort) => RepositoryProvider.of<Api>(context).drawer.get(),
                          ),
                        ),
                      )
                    : const SizedBox();
              },
            )
          ],
        ),
        bottomNavigationBar: BlocBuilder<AuthC, AuthS>(
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.all(CSpace.mediumSmall),
              child: ElevatedButton(
                onPressed: () => state.status == AppStatus.success
                    ? UDialog().showConfirm(
                        text: 'Đăng xuất tài khoản khỏi ứng dụng?',
                        btnOkOnPress: () async {
                          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                          sharedPreferences.clear();
                          await UDialog().delay();
                          context.goNamed(CRoute.login);
                        })
                    : context.goNamed(CRoute.login),
                style: CStyle.button,
                child: Text(state.status == AppStatus.success
                    ? 'widgets.drawer.Log out'.tr()
                    : 'pages.login.login.Log in'.tr()),
              ),
            );
          },
        ),
      ),
    ),
  );
}
