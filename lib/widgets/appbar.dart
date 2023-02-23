import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/index.dart';

appBar({required title, required BuildContext context}) {
  double height = AppBar().preferredSize.height;
  double h = MediaQuery.of(context).viewPadding.top - Space.large;
  return PreferredSize(
    preferredSize: Size(MediaQuery.of(context).size.width, height + h),
    child: Stack(
      children: <Widget>[
        Container(
          color: Colors.transparent,
          height: height + h,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: Space.medium + h),
          child: Center(
            child: Text(title, style: Style.title),
          ),
        ),
        Positioned(
          top: Space.large + h,
          left: Space.large,
          right: Space.large,
          child: AppBar(
            toolbarHeight: Height.mediumSmall,
            leadingWidth: Height.mediumSmall,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.only(bottom: Height.mediumSmall / 10),
              child: ElevatedButton(
                style: Style.buttonIcon,
                child: AppIcons.arrowLeft,
                onPressed: () {
                  if (GoRouter.of(context).canPop()) {
                    GoRouter.of(context).pop();
                  }
                },
              ),
            ),
            primary: false,
          ),
        )
      ],
    ),
  );
}
