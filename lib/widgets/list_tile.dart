import 'package:flutter/material.dart';

import '/constants/index.dart';

listTile(
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
                color: ColorName.black.shade100,
              )))
            : const BoxDecoration(),
        padding: const EdgeInsets.symmetric(vertical: Space.medium),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: Height.mediumSmall * 1.8,
              child: leading != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(Space.small), // Image border
                      child: leading,
                    )
                  : const SizedBox(),
            ),
            const SizedBox(width: Space.medium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  const SizedBox(height: Space.superSmall / 2),
                  content ?? const SizedBox(),
                ],
              ),
            ),
            trailing ?? const SizedBox(),
          ],
        ),
      ),
    );
