import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/constants/index.dart';

appBar({
  required String title,
  String? backTitle,
  Function()? pop,
  TextStyle? titleStyle,
  List<Widget>? actions,
  Widget? bottom,
  Widget? leading,
  Color? backColor,
  Color? backgroundColor,
  double? leadingWidth,
  double toolbarHeight = 40,
  bool isHideLeading = false,
}) {
  final BuildContext context = rootNavigatorKey.currentState!.context;
  return PreferredSize(
    preferredSize: Size(MediaQuery.of(context).size.width, toolbarHeight),
    child: Builder(builder: (context) {
      final ScaffoldState? scaffold = Scaffold.maybeOf(context);
      final bool hasDrawer = scaffold?.hasDrawer ?? false;
      List<Widget> action = [];
      if (leading == null) {
        if (hasDrawer) {
          leading = Padding(
            padding: const EdgeInsets.only(left: CSpace.sm),
            child: InkWell(
              key: const ValueKey("drawer_menu"),
              splashColor: CColor.primary.shade100,
              child: Container(
                height: 40,
                width: 40,
                color: Colors.transparent,
                child: const Icon(Icons.menu, color: Colors.white),
              ),
              onTap: () => Scaffold.of(context).openDrawer(),
            ),
          );
        } else if (context.canPop() && !isHideLeading) {
          leading = InkWell(
            key: const ValueKey("back_screen"),
            splashColor: CColor.primary.shade100,
            child: Container(
              width: 40,
              height: 40,
              color: Colors.transparent,
              child: Icon(Icons.arrow_back_ios_rounded, color: backColor ?? Colors.white),
            ),
            onTap: () {
              if (pop != null) {
                pop();
                return;
              }
              GoRouter.of(context).pop();
            },
          );
        }
      }

      return AppBar(
        toolbarHeight: toolbarHeight,
        title: Text(title,
            key: ValueKey(title),
            style: const TextStyle(fontSize: CFontSize.base, fontWeight: FontWeight.w600, color: Colors.white)
                .merge(titleStyle)),
        centerTitle: true,
        leadingWidth: leadingWidth ?? (50),
        backgroundColor: backgroundColor ?? CColor.primary,
        shadowColor: Colors.transparent,
        leading: leading ?? Container(),
        actions: actions ?? action,
        bottom: bottom != null
            ? PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: bottom,
              )
            : null,
      );
    }),
  );
}
