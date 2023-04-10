import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/constants/index.dart';
import '/widgets/index.dart';
import '../../models/index.dart';
import '../../utils/index.dart';

drawer() {
  BuildContext context = rootNavigatorKey.currentState!.context;
  // final ScrollController controller = ScrollController();
  return PageStorage(
    bucket: CPref.bucket,
    child: Drawer(
      key: const PageStorageKey<String>('page_store'),
      elevation: 20,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/svgs/logo.svg',
                width: MediaQuery.of(context).size.width * 0.28,
                color: CColor.black,
              ),
              const SizedBox(height: 10),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: CSpace.large),
                      child: WList(
                        item: (content, index) {
                          final DrawerData drawer = content;
                          if (drawer.subChild!.isNotEmpty) {
                            return ExpansionTileCard(
                              key: PageStorageKey<String>(drawer.urlRewrite ?? ''),
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
                              title: Text(
                                drawer.name!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: CFontSize.headline4,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              titlePadding: const EdgeInsets.fromLTRB(0, CSpace.medium, CSpace.medium, CSpace.medium),
                              trailing: CIcon.arrowRight,
                              children: [
                                line(color: CColor.black.shade100),
                                PageStorage(
                                  bucket: CPref.bucket,
                                  child: ListView.separated(
                                      padding: const EdgeInsets.only(left: CSpace.large),
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
                                                  0, CSpace.medium, CSpace.medium, CSpace.medium),
                                              // color:
                                              // RoutesGenerator.routerName == subChild[index].urlRewrite
                                              //     ? AppThemes.primaryColor.withOpacity(0.1)
                                              //     : null,
                                              child: Text(
                                                drawer.subChild![index].name!,
                                                style: const TextStyle(
                                                  fontSize: CFontSize.headline4,
                                                  // color: RoutesGenerator.routerName ==
                                                  //     subChild[index].urlRewrite
                                                  //     ? AppThemes.primaryColor
                                                  //     : Colors.black,
                                                ),
                                              )),
                                        );
                                      }),
                                ),
                              ],
                            );
                          }
                          return InkWell(
                            key: PageStorageKey<String>(drawer.urlRewrite ?? ''),
                            onTap: () => context.goNamed(drawer.urlRewrite!),
                            child: Container(
                                // color: CRoute.routerName == drawer.urlRewrite
                                //     ? AppThemes.primaryColor.withOpacity(0.1)
                                //     : null,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.fromLTRB(0, CSpace.medium, CSpace.medium, CSpace.medium),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        drawer.name!,
                                        style: TextStyle(
                                          fontWeight: drawer.subChild!.isNotEmpty ? FontWeight.w600 : FontWeight.w400,
                                          fontSize: CFontSize.headline4,
                                          // color: RoutesGenerator.routerName ==
                                          //     drawer.urlRewrite
                                          //     ? AppThemes.primaryColor
                                          //     : Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    CIcon.arrowRight
                                  ],
                                )),
                          );
                        },
                        format: DrawerData.fromJson,
                        separator: line(color: CColor.black.shade100),
                        api: (filter, page, size, sort) => RepositoryProvider.of<Api>(context).drawer.get(),
                      )))
            ],
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(CSpace.mediumSmall),
            child: ElevatedButton(
              onPressed: () async {
                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                sharedPreferences.clear();
                if (context.mounted) {
                  context.goNamed(CRoute.login);
                }
              },
              style: CStyle.button,
              child: Text('widgets.drawer.Log out'.tr()),
            ),
          ),
        ),
      ),
    ),
  );
}
