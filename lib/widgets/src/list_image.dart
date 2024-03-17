import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/models/index.dart';

listImage({required List listImage, double? height}) {
  if (listImage is List<String>) listImage = listImage.map((e) => MUpload.fromJson({"fileUrl": e})).toList();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const VSpacer(CSpace.xl3),
      listImage.isNotEmpty
          ? Builder(builder: (_) {
        final double extend = listImage.length <= 3
            ? 1
            : listImage.length % 3 == 0
            ? listImage.length / 3
            : listImage.length ~/ 3 + 1;
        return SizedBox(
          height: height != null
              ? (CSpace.width / 3) * extend < height
              ? (CSpace.width / 3) * extend
              : height
              : (CSpace.width / 3) * extend,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listImage.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: CSpace.xl,
              crossAxisSpacing: CSpace.xl,
            ),
            itemBuilder: (_, index) => listImageNetwork(
              url: listImage[index].fileUrl,
              listUrl: listImage as List<MUpload>,
              borderRadius: BorderRadius.circular(CSpace.base),
            ),
          ),
        );
      })
          : Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: CSpace.xl2),
            child: Text('widgets.list.details.Empty'.tr(), style: TextStyle(color: CColor.black.shade300)),
          ),
        ],
      )
    ],
  );
}
