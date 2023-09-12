import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/constants/index.dart';
import '/core/index.dart';

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
            padding: const EdgeInsets.only(left: CSpace.small),
            child: InkWell(
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
            splashColor: CColor.primary.shade100,
            child: Container(
              width: 105,
              height: 40,
              color: Colors.transparent,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const HSpacer(CSpace.medium),
                  Icon(Icons.arrow_back_ios_rounded, color: backColor ?? Colors.white),
                  Text(
                    backTitle ?? 'Quay lại',
                    style: TextStyle(fontSize: CFontSize.body, color: backColor ?? Colors.white),
                  ),
                ],
              ),
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
            style: const TextStyle(fontSize: CFontSize.body, fontWeight: FontWeight.w600, color: Colors.white)
                .merge(titleStyle)),
        centerTitle: true,
        leadingWidth: leadingWidth ?? (hasDrawer ? 50 : 105),
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