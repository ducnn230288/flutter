import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/utils.dart';

itemDrawer({required String svg, required String name, onTap, bool isBorder = true}) => ListTile(
      minLeadingWidth: 0,
      contentPadding: EdgeInsets.only(right: AppThemes.gap),
      leading: SvgPicture.asset(
        svg,
        semanticsLabel: name,
        width: 24,
        color: AppThemes.blackColor,
      ),
      shape: Border(
        bottom: BorderSide(width: 0, color: isBorder ? AppThemes.blackColor : Colors.transparent),
      ),
      title: Text(
        name,
        style: TextStyle(color: AppThemes.blackColor, fontSize: 16),
      ),
      trailing: SvgPicture.asset(
        'assets/svgs/arrow-right.svg',
        semanticsLabel: name,
        width: 12,
        color: AppThemes.primaryColor,
      ),
      onTap: onTap,
    );
