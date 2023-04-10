import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/constants/index.dart';

appBar({required title, Function()? pop, List<Widget>? actions}) {
  BuildContext context = rootNavigatorKey.currentState!.context;
  double height = AppBar().preferredSize.height;
  double h = MediaQuery.of(context).viewPadding.top;
  return PreferredSize(
    preferredSize: Size(MediaQuery.of(context).size.width, height + h),
    child: Stack(
      children: <Widget>[
        Container(
          color: Colors.transparent,
          height: height + h,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: CSpace.medium + h),
          child: Center(
            child: Text(title, style: CStyle.title),
          ),
        ),
        Positioned(
          top: CSpace.large + h,
          left: CSpace.large,
          right: CSpace.large,
          child: Builder(builder: (context) {
            final ScaffoldState? scaffold = Scaffold.maybeOf(context);
            // final bool hasDrawer = scaffold?.hasDrawer ?? false;
            final bool hasEndDrawer = scaffold?.hasEndDrawer ?? false;
            Widget leading = Container();
            List<Widget> action = [];
            // if (hasDrawer) {
            //   leading = ElevatedButton(
            //     style: CStyle.buttonIcon,
            //     child: const Icon(Icons.menu),
            //     onPressed: () => Scaffold.of(context).openDrawer(),
            //   );
            // } else
            if (GoRouter.of(context).canPop()) {
              leading = Padding(
                padding: const EdgeInsets.only(bottom: CHeight.mediumSmall / 10),
                child: ElevatedButton(
                  style: CStyle.buttonIcon,
                  child: CIcon.arrowLeft,
                  onPressed: () {
                    if (pop != null) {
                      pop();
                      return;
                    }
                    GoRouter.of(context).pop();
                  },
                ),
              );
            }
            if (hasEndDrawer) {
              action = [
                SizedBox(
                  width: 40,
                  child: ElevatedButton(
                    style: CStyle.buttonIcon,
                    child: const Icon(Icons.filter),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                )
              ];
            }
            return AppBar(
              toolbarHeight: CHeight.mediumSmall,
              leadingWidth: CHeight.mediumSmall,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              leading: leading,
              actions: actions ?? action,
              primary: false,
            );
          }),
        )
      ],
    ),
  );
}
