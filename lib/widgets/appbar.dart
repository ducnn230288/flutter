import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/utils.dart';

appBar({title, context}) {
  double height = AppBar().preferredSize.height;
  double h = MediaQuery.of(context).viewPadding.top - 15;
  return PreferredSize(
    preferredSize: Size(MediaQuery.of(context).size.width, height + h),
    child: Stack(
      children: <Widget>[
        Container(
          color: Colors.transparent,
          height: height + h,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 13.0 + h),
          child: Center(
            child: Text(
              title,
              style: AppThemes.titleStyle,
            ),
          ),
        ),
        Positioned(
          top: AppThemes.gap + h,
          left: AppThemes.gap,
          right: AppThemes.gap,
          child: AppBar(
            toolbarHeight: 40,
            leadingWidth: 40,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: ElevatedButton(
                child: SvgPicture.asset(
                  'assets/svgs/arrow-left.svg',
                  semanticsLabel: 'arrow left',
                  width: 24,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            primary: false,
          ),
        )
      ],
    ),
  );
}
