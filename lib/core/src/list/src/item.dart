import 'package:flutter/material.dart';

import '/constants/index.dart';

itemList(
        {required Widget title,
        Widget? content,
        Widget? leading,
        Widget? trailing,
        VoidCallback? onTap,
        bool borderShow = true}) =>
    InkWell(
      onTap: onTap,
      child: Container(
        decoration: borderShow
            ? BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                width: 0,
                color: CColor.black.shade100,
              )))
            : const BoxDecoration(),
        padding: const EdgeInsets.symmetric(vertical: CSpace.medium),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            leading != null
                ? SizedBox(
                    width: CHeight.mediumSmall * 1.8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(CSpace.small),
                      // Image border
                      child: leading,
                    ),
                  )
                : const SizedBox(),
            leading != null ? const SizedBox(width: CSpace.medium) : const SizedBox(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  const SizedBox(height: CSpace.superSmall / 2),
                  content ?? const SizedBox(),
                ],
              ),
            ),
            trailing ?? const SizedBox(),
          ],
        ),
      ),
    );
