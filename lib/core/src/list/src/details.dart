import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/models/index.dart';
import '/utils/index.dart';
import '/widgets/index.dart';

class DataDetails extends StatelessWidget {
  final MFormItem data;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? fontSize;
  final bool showBorder;

  const DataDetails({
    super.key,
    required this.data,
    this.horizontalPadding,
    this.verticalPadding,
    this.fontSize,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    switch (data.dataType) {
      case DataType.separation:
        return Container(
          key: ValueKey(data.label),
          padding: const EdgeInsets.symmetric(
              horizontal: CSpace.xl3, vertical: CSpace.xl),
          color: CColor.black.shade100.withOpacity(0.2),
          alignment: Alignment.topLeft,
          child: Text(data.label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: CFontSize.base)),
        );
      case DataType.image:
        if (data.value.runtimeType != List<MUpload>) {
          AppConsole.dump('data.value.runtimeType is not List<MUpload>',
              name: 'runTimeType');
          return Container();
        }
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical:
                data.label != '' ? verticalPadding ?? CSpace.xs : 0,
            horizontal: horizontalPadding ?? CSpace.xl3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: CSpace.sm),
                child: Text('${data.label}  ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: CFontSize.base,
                    )),
              ),
              data.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: CSpace.base),
                      child: GridView.builder(
                        physics: const ScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: CSpace.xl,
                            mainAxisSpacing: CSpace.xl,
                            mainAxisExtent: CSpace.width / 3),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: data.value.length,
                        itemBuilder: (context, index) => listImageNetwork(
                          url: data.value[index].fileUrl,
                          fit: BoxFit.cover,
                          listUrl: data.value ?? [],
                          borderRadius: BorderRadius.circular(CSpace.sm),
                        ),
                      ),
                    )
                  : Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '(${'widgets.list.details.Empty'.tr()})',
                        style: TextStyle(
                            color: CColor.black.shade300, fontSize: fontSize),
                      ),
                    )
            ],
          ),
        );
      default:
        return Container(
          color: Colors.white,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (data.icon != null)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: data.label != ''
                                ? verticalPadding ?? CSpace.xl
                                : 0,
                            horizontal: horizontalPadding ?? CSpace.xl3,
                          ),
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: CSpace.sm, right: CSpace.sm),
                            child: SvgPicture.asset(
                              data.icon ?? '',
                              semanticsLabel: data.label,
                            ),
                          ),
                        ),
                      if (data.label != '')
                        Padding(
                          padding: EdgeInsets.only(
                            top: data.label != ''
                                ? verticalPadding ?? CSpace.xl3 - 5
                                : 0,
                            bottom: data.label != ''
                                ? verticalPadding ?? CSpace.xl3 - 5
                                : 0,
                            left: horizontalPadding ?? CSpace.xl3,
                          ),
                          child: Text('${data.label}  ',
                              style: TextStyle(
                                  color: CColor.black.shade300,
                                  fontSize: fontSize)),
                        ),
                      if (data.dataType != DataType.column)
                        Expanded(
                          child: Container(
                            alignment: data.label != ''
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Content(
                              key: ValueKey(data.label),
                              data: data,
                              fontSize: fontSize,
                              verticalPadding: data.label != ''
                                  ? verticalPadding ?? CSpace.xl
                                  : 0,
                              horizontalPadding:
                                  horizontalPadding ?? CSpace.xl3,
                            ),
                          ),
                        )
                    ],
                  ),
                  if (data.dataType == DataType.column)
                    data.value != ''
                        ? DescriptionTextWidget(
                            key: ValueKey(data.label),
                            text: data.value,
                            style: TextStyle(
                              fontWeight:
                                  data.bold ? FontWeight.w600 : FontWeight.w400,
                              color: data.color,
                              fontSize: fontSize,
                            ),
                            textAlign: TextAlign.right,
                          )
                        : data.child ??
                            Container(
                              height: 30,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '(${'widgets.list.details.Empty'.tr()})',
                                style: TextStyle(
                                    color: CColor.black.shade300,
                                    fontSize: fontSize),
                              ),
                            ),
                ],
              ),
              if (showBorder) line(),
            ],
          ),
        );
    }
  }
}

class Content extends StatelessWidget {
  final MFormItem data;
  final double? fontSize;
  final double verticalPadding;
  final double horizontalPadding;

  const Content({
    super.key,
    required this.data,
    this.fontSize,
    required this.verticalPadding,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    if (data.child != null) {
      return Container(
        margin: EdgeInsets.only(
            top: verticalPadding,
            right: horizontalPadding,
            left: horizontalPadding),
        child: data.child!,
      );
    }
    if (data.value == '') {
      return Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(
          right: horizontalPadding,
          top: verticalPadding,
          bottom: verticalPadding,
        ),
        child: Text(
          '(${'widgets.list.details.Empty'.tr()})',
          style: TextStyle(color: CColor.black.shade300, fontSize: fontSize),
        ),
      );
    }
    if (data.dataType == DataType.phone) {
      return Column(
        children: [
          SizedBox(height: verticalPadding / 3),
          Container(
            width: data.value.length.toDouble() * 15,
            height: CHeight.sm,
            padding: EdgeInsets.only(right: horizontalPadding),
            child: InkWell(
              splashColor: CColor.primary.shade100,
              onLongPress: () {
                if (data.dataType == DataType.phone) {
                  Clipboard.setData(ClipboardData(text: data.value));
                  USnackBar.smallSnackBar(
                      title: 'widgets.list.details.Phone number copied'.tr(),
                      width: 180);
                }
              },
              child: ElevatedButton(
                  style: CStyle.buttonSmall,
                  onPressed: () async {
                    await launchUrl(Uri(scheme: 'tel', path: data.value));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.phone_outlined,
                          color: Colors.white, size: CFontSize.xl),
                      const HSpacer(CSpace.sm),
                      Text(
                        Convert.phoneNumber(data.value),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: fontSize),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      );
    }
    if (data.dataType == DataType.status) {
      return Padding(
          padding: EdgeInsets.only(
              top: CSpace.xl + 1, right: horizontalPadding),
          child: status(data.value,
              height: CHeight.lg / 2, fontSize: CFontSize.xs));
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(
              right: data.dataType == DataType.copy
                  ? CSpace.xs / 2
                  : horizontalPadding,
              top: verticalPadding,
              bottom: verticalPadding,
            ),
            child: DescriptionTextWidget(
              text: data.value,
              style: TextStyle(
                fontWeight: data.bold ? FontWeight.w600 : FontWeight.w400,
                color: data.color,
                fontSize: fontSize,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        if (data.dataType == DataType.copy)
          Container(
            height: CFontSize.base,
            width: 25,
            margin: EdgeInsets.only(
                right: horizontalPadding * 0.8, top: verticalPadding),
            child: InkWell(
              splashColor: CColor.primary.shade100,
              onTap: () {
                Clipboard.setData(ClipboardData(text: data.value));
                USnackBar.smallSnackBar(
                    title: 'widgets.list.details.Successfully copied'.tr(),
                    width: 170);
              },
              child: CIcon.copy,
            ),
          )
      ],
    );
  }
}
