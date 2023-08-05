import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/constants/index.dart';

listTile({required String svg, required String name, onTap, bool isBorder = true}) => ListTile(
      minLeadingWidth: 0,
      contentPadding: const EdgeInsets.only(right: 0),
      leading: SvgPicture.asset(svg, semanticsLabel: name, width: 24, color: CColor.black),
      shape: Border(bottom: BorderSide(width: 0, color: isBorder ? CColor.black.shade100 : Colors.transparent)),
      title: Text(name, style: TextStyle(color: CColor.black, fontSize: CFontSize.body)),
      trailing: CIcon.arrowRight,
      onTap: onTap,
    );
