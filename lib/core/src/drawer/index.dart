import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/utils/index.dart';

class CDrawer extends StatefulWidget {
  const CDrawer({super.key});

  @override
  DrawerState createState() => DrawerState();
}

class DrawerState extends State<CDrawer> with TickerProviderStateMixin {
  final Map<String, AnimationController> _listController = {};
  final Map<String, Animation<double>> _listAnimation = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    for (var element in _listController.values) {
      element.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double widthDrawer = CSpace.width * 0.8;
    double widthImage = CSpace.width * 0.25;
    final double widthInfo = widthDrawer - widthImage - 2 * CSpace.xs;
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
                                        child: CIcon.logoLogin,
                                      ),
                                      state.status == AppStatus.success
                                          ? Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: CFontSize.xl,
                                                  width: widthInfo,
                                                  alignment: Alignment.centerLeft,
                                                  child: FittedBox(
                                                    child: Text(
                                                      state.user!.name,
                                                      style: const TextStyle(
                                                          fontSize: CFontSize.xl, fontWeight: FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: CFontSize.sm,
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
                                                CSpace.base,
                                                CSpace.xl,
                                                CSpace.xl,
                                                CSpace.xl,
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
                          child: ListView.separated(
                              padding: const EdgeInsets.all(8),
                              itemCount: state.listNavigation!.length,
                              itemBuilder: (BuildContext context, int index) {
                                final navigation = state.listNavigation![index];
                                _listController[navigation.id!] =
                                    AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
                                _listAnimation[navigation.id!] = Tween(begin: 0.0, end: 0.25).animate(
                                    CurvedAnimation(parent: _listController[navigation.id]!, curve: Curves.easeOut));
                                if (navigation.subChild!.isNotEmpty) {
                                  return ExpansionTileCard(
                                    onExpansionChanged: (status) {
                                      if (status) {
                                        _listController[navigation.id!]!.forward();
                                      } else {
                                        _listController[navigation.id!]!.reverse();
                                      }
                                    },
                                    scrollSettings: () async {},
                                    title: Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: CSpace.base),
                                        child: Text(
                                          navigation.name!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontSize: CFontSize.base,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                    titlePadding:
                                    const EdgeInsets.fromLTRB(0, CSpace.xl, CSpace.xl, CSpace.xl),
                                    trailing:
                                    RotationTransition(turns: _listAnimation[navigation.id!]!, child: CIcon.arrowRight),
                                    children: [
                                      line(color: CColor.black.shade100),
                                      ListView.separated(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          separatorBuilder: (_, index) {
                                            return line(color: CColor.black.shade100);
                                          },
                                          itemCount: navigation.subChild?.length ?? 0,
                                          itemBuilder: (_, index) {
                                            return InkWell(
                                              onTap: () {
                                                context.goNamed(navigation.subChild![index].urlRewrite!);
                                              },
                                              child: Container(
                                                  padding: const EdgeInsets.fromLTRB(
                                                    CSpace.xl3,
                                                    CSpace.xl,
                                                    CSpace.xl,
                                                    CSpace.xl,
                                                  ),
                                                  child: Text(
                                                    navigation.subChild![index].name!,
                                                    style: const TextStyle(
                                                      fontSize: CFontSize.base,
                                                    ),
                                                  )),
                                            );
                                          }),
                                    ],
                                  );
                                }
                                return InkWell(
                                  onTap: () => context.goNamed(navigation.urlRewrite!),
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.fromLTRB(
                                        CSpace.base,
                                        CSpace.xl,
                                        CSpace.xl,
                                        CSpace.xl,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              navigation.name!,
                                              style: TextStyle(
                                                fontWeight:
                                                navigation.subChild!.isNotEmpty ? FontWeight.w600 : FontWeight.w400,
                                                fontSize: CFontSize.base,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      )),
                                );
                              },
                              separatorBuilder: (_, int index) => line(color: CColor.black.shade100),
                          )
                        )
                      : const SizedBox();
                },
              )
            ],
          ),
          bottomNavigationBar: BlocBuilder<AuthC, AuthS>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(CSpace.base),
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
}
