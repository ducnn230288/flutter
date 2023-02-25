import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/constants/index.dart';

itemDrawer({required String svg, required String name, onTap, bool isBorder = true}) => ListTile(
      minLeadingWidth: 0,
      contentPadding: const EdgeInsets.only(right: Space.large),
      leading: SvgPicture.asset(
        svg,
        semanticsLabel: name,
        width: 24,
        color: ColorName.black,
      ),
      shape: Border(
        bottom: BorderSide(width: 0, color: isBorder ? ColorName.black.shade200 : Colors.transparent),
      ),
      title: Text(
        name,
        style: TextStyle(color: ColorName.black, fontSize: FontSizes.headline4),
      ),
      trailing: AppIcons.arrowRight,
      onTap: onTap,
    );
