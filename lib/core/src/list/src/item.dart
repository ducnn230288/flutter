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
        padding: const EdgeInsets.symmetric(vertical: CSpace.xl),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            leading != null
                ? SizedBox(
                    width: CHeight.lg * 1.8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(CSpace.sm),
                      // Image border
                      child: leading,
                    ),
                  )
                : const SizedBox(),
            leading != null ? const SizedBox(width: CSpace.xl) : const SizedBox(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  const SizedBox(height: CSpace.xs / 2),
                  content ?? const SizedBox(),
                ],
              ),
            ),
            trailing ?? const SizedBox(),
          ],
        ),
      ),
    );
