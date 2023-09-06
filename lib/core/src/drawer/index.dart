import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';

drawer() {
  BuildContext context = rootNavigatorKey.currentState!.context;
  final double widthDrawer = CSpace.width * 0.8;
  final double widthImage = CSpace.width * 0.22;
  const double space = CSpace.mediumSmall;
  final double widthInfo = widthDrawer - widthImage - 2 * space;
  // final ScrollController controller = ScrollController();
  return Drawer(
    // key: const PageStorageKey<String>('page_store'),
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
                BlocBuilder<AuthC, AuthS>(
                  builder: (context, state) {
                    return InkWell(
                      splashColor: CColor.primary.shade100,
                      onTap: () => context.pushNamed(CRoute.myAccountInfo),
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Container(
                              height: widthImage,
                              width: widthImage,
                              padding: const EdgeInsets.all(CSpace.medium),
                              margin: const EdgeInsets.symmetric(horizontal: space),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white, width: 2),
                                color: CColor.primary,
                                boxShadow: const [
                                  BoxShadow(color: Colors.grey, offset: Offset(0.5, 0.5), blurRadius: 1)
                                ],
                                shape: BoxShape.circle,
                              ),
                              child: FittedBox(
                                  child: Text(
                                state.user!.name.substring(0, 2),
                                style: const TextStyle(color: Colors.white),
                              )),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: CFontSize.title3,
                                  width: widthInfo,
                                  alignment: Alignment.centerLeft,
                                  child: FittedBox(
                                    child: Text(
                                      state.user!.name,
                                      style: const TextStyle(fontSize: CFontSize.title3, fontWeight: FontWeight.w600),
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
                                            style: TextStyle(color: CColor.hintColor),
                                          ),
                                        )
                                      : Container(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocProvider(
                create: (context) => BlocC(),
                child: WList<dynamic>(
                  item: (content, index) {
                    final DrawerData drawer = content;
                    if (drawer.subChild!.isNotEmpty) {
                      return ExpansionTileCard(
                        // key: PageStorageKey<String>(drawer.urlRewrite ?? ''),
                        scrollSettings: () async {
                          // if (controller.position.extentAfter < 25) {
                          //   await Utils.delay();
                          // }
                          // controller.animateTo(
                          //   controller.position.maxScrollExtent + 100,
                          //   duration: const Duration(milliseconds: 200),
                          //   curve: Curves.easeIn,
                          // );
                        },
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
                        titlePadding: const EdgeInsets.fromLTRB(0, CSpace.medium, CSpace.medium, CSpace.medium),
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
                                      // color:
                                      // RoutesGenerator.routerName == subChild[index].urlRewrite
                                      //     ? AppThemes.primaryColor.withOpacity(0.1)
                                      //     : null,
                                      child: Text(
                                        drawer.subChild![index].name!,
                                        style: const TextStyle(
                                          fontSize: CFontSize.callOut,
                                          // color: RoutesGenerator.routerName ==
                                          //     subChild[index].urlRewrite
                                          //     ? AppThemes.primaryColor
                                          //     : Colors.black,
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
                          // color: CRoute.routerName == drawer.urlRewrite
                          //     ? AppThemes.primaryColor.withOpacity(0.1)
                          //     : null,
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
                                    fontWeight: drawer.subChild!.isNotEmpty ? FontWeight.w600 : FontWeight.w400,
                                    fontSize: CFontSize.callOut,
                                    // color: RoutesGenerator.routerName ==
                                    //     drawer.urlRewrite
                                    //     ? AppThemes.primaryColor
                                    //     : Colors.black,
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
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(CSpace.mediumSmall),
          child: ElevatedButton(
            onPressed: () => UDialog().showConfirm(
                text: 'Đăng xuất tài khoản khỏi ứng dụng?',
                btnOkOnPress: () async {
                  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                  sharedPreferences.clear();
                  await UDialog().delay();
                  context.goNamed(CRoute.login);
                }),
            style: CStyle.button,
            child: Text('widgets.drawer.Log out'.tr()),
          ),
        ),
      ),
    ),
  );
}
