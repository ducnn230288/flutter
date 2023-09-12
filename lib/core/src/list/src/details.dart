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
    Key? key,
    required this.data,
    this.horizontalPadding,
    this.verticalPadding,
    this.fontSize,
    this.showBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (data.dataType) {
      case DataType.separation:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: CSpace.large, vertical: CSpace.medium),
          color: CColor.black.shade100.withOpacity(0.4),
          alignment: Alignment.topLeft,
          child: Text(data.label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: CFontSize.body)),
        );
      case DataType.image:
        if (data.value.runtimeType != List<MUpload>) {
          AppConsole.dump('data.value.runtimeType is not List<MUpload>', name: 'runTimeType');
          return Container();
        }
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: data.label != '' ? verticalPadding ?? CSpace.superSmall : 0,
            horizontal: horizontalPadding ?? CSpace.large,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: CSpace.small),
                child: Text('${data.label}  ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: CFontSize.body,
                    )),
              ),
              data.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: CSpace.mediumSmall),
                      child: GridView.builder(
                        physics: const ScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: CSpace.medium,
                            mainAxisSpacing: CSpace.medium,
                            mainAxisExtent: CSpace.width / 3),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: data.value.length,
                        itemBuilder: (context, index) => listImageNetwork(
                          url: data.value[index].fileUrl,
                          fit: BoxFit.cover,
                          listUrl: data.value ?? [],
                          borderRadius: BorderRadius.circular(CSpace.small),
                        ),
                      ),
                    )
                  : Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '(${'widgets.list.details.Empty'.tr()})',
                        style: TextStyle(color: CColor.black.shade300, fontSize: fontSize),
                      ),
                    )
            ],
          ),
        );
      default:
        return Container(
          color: CColor.primary.shade50.withOpacity(0.2),
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
                            vertical: data.label != '' ? verticalPadding ?? CSpace.large - 5 : 0,
                            horizontal: horizontalPadding ?? CSpace.large,
                          ),
                          child: Container(
                            padding: const EdgeInsets.only(top: CSpace.small, right: CSpace.small),
                            child: SvgPicture.asset(
                              data.icon ?? '',
                              semanticsLabel: data.label,
                            ),
                          ),
                        ),
                      if (data.label != '')
                        Padding(
                          padding: EdgeInsets.only(
                            top: data.label != '' ? verticalPadding ?? CSpace.large - 5 : 0,
                            bottom: data.label != '' ? verticalPadding ?? CSpace.large - 5 : 0,
                            left: horizontalPadding ?? CSpace.large,
                          ),
                          child: Text('${data.label}  ',
                              style: TextStyle(color: CColor.black.shade300, fontSize: fontSize)),
                        ),
                      if (data.dataType != DataType.column)
                        Expanded(
                          child: Container(
                            alignment: data.label != '' ? Alignment.centerRight : Alignment.centerLeft,
                            child: Content(
                              data: data,
                              fontSize: fontSize,
                              verticalPadding: data.label != '' ? verticalPadding ?? CSpace.large - 5 : 0,
                              horizontalPadding: horizontalPadding ?? CSpace.large,
                            ),
                          ),
                        )
                    ],
                  ),
                  if (data.dataType == DataType.column)
                    data.value != ''
                        ? DescriptionTextWidget(
                            text: data.value,
                            style: TextStyle(
                              fontWeight: data.bold ? FontWeight.w600 : FontWeight.w400,
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
                                style: TextStyle(color: CColor.black.shade300, fontSize: fontSize),
                              ),
                            ),
                ],
              ),
              showBorder ? line() : SizedBox(),
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
    Key? key,
    required this.data,
    this.fontSize,
    required this.verticalPadding,
    required this.horizontalPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.child != null) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
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
          SizedBox(height: verticalPadding / 2),
          Container(
            width: 170,
            height: CHeight.superSmall,
            padding: EdgeInsets.only(right: horizontalPadding),
            child: InkWell(
              splashColor: CColor.primary.shade100,
              onLongPress: () {
                if (data.dataType == DataType.phone) {
                  Clipboard.setData(ClipboardData(text: data.value));
                  USnackBar.smallSnackBar(title: 'widgets.list.details.Phone number copied'.tr(), width: 180);
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
                      const Icon(Icons.phone_outlined, color: Colors.white, size: CFontSize.title3),
                      const HSpacer(CSpace.small),
                      Text(
                        Convert.phoneNumber(data.value),
                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: fontSize),
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
          padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
          child: status(data.value, height: CHeight.mediumSmall / 2, fontSize: CFontSize.footnote));
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(
              right: horizontalPadding,
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
            height: CFontSize.subhead,
            width: 25,
            margin: const EdgeInsets.only(left: 3),
            child: InkWell(
              splashColor: CColor.primary.shade100,
              onTap: () {
                Clipboard.setData(ClipboardData(text: data.value));
                USnackBar.smallSnackBar(title: 'widgets.list.details.Successfully copied'.tr(), width: 170);
              },
              child: CIcon.copy,
            ),
          )
      ],
    );
  }
}