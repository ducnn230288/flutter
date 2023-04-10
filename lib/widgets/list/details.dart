import 'package:easy_localization/easy_localization.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '/constants/index.dart';
import '/models/index.dart';
import '/utils/index.dart';

class DataDetails extends StatelessWidget {
  final MFormItem data;

  const DataDetails({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (data.dataType) {
      case DataType.separation:
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: CSpace.mediumSmall, horizontal: CSpace.large),
          color: CColor.black.shade100,
          child: Text(
            data.label,
            style: const TextStyle(
              fontSize: CFontSize.headline4,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      case DataType.image:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: CSpace.superSmall, horizontal: CSpace.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data.icon != null)
                    Container(
                      padding: const EdgeInsets.only(top: CSpace.small, right: CSpace.small),
                      child: SvgPicture.asset(
                        data.icon ?? '',
                        semanticsLabel: data.label,
                        width: CFontSize.headline3,
                        color: CColor.black.shade400,
                      ),
                    ),
                  Container(
                    margin: const EdgeInsets.only(top: CSpace.small),
                    child: Text(
                      '${data.label}  ',
                      style: const TextStyle(fontSize: CFontSize.paragraph1, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              data.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: CSpace.mediumSmall),
                      child: GridView.builder(
                        physics: const ScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          childAspectRatio: 1.15,
                        ),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: data.value.length,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => ExtendedImageGesturePageView.builder(
                                      controller: ExtendedPageController(
                                        initialPage: index,
                                        pageSpacing: 0,
                                      ),
                                      preloadPagesCount: 0,
                                      itemCount: data.value.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Stack(
                                          clipBehavior: Clip.none,
                                          alignment: AlignmentDirectional.center,
                                          children: [
                                            ExtendedImage.network(
                                              data.value[index],
                                              fit: BoxFit.contain,
                                              mode: ExtendedImageMode.gesture,
                                              initGestureConfigHandler: (ExtendedImageState state) => GestureConfig(
                                                inPageView: true,
                                                initialScale: 1.0,
                                                maxScale: 5.0,
                                                animationMaxScale: 6.0,
                                                initialAlignment: InitialAlignment.center,
                                              ),
                                            ),
                                            Positioned(
                                              right: CSpace.small,
                                              top: CSpace.small,
                                              width: CHeight.medium / 1.3,
                                              height: CHeight.medium / 1.3,
                                              child: GestureDetector(
                                                onTap: () => Navigator.of(context).pop(),
                                                child: Container(
                                                  padding: const EdgeInsets.all(CSpace.medium),
                                                  decoration: BoxDecoration(
                                                    color: CColor.black,
                                                    borderRadius:
                                                        const BorderRadius.all(Radius.circular(CSpace.medium)),
                                                  ),
                                                  child: Wrap(
                                                    alignment: WrapAlignment.center,
                                                    children: [CIcon.close],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(CSpace.small), // Image border
                            child: ExtendedImage.network(
                              data.value[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '(${'widgets.list.details.Empty'.tr()})',
                        style: TextStyle(color: CColor.black.shade300),
                      ),
                    )
            ],
          ),
        );
      default:
        return Padding(
          padding: const EdgeInsets.fromLTRB(CSpace.large, CSpace.superSmall, CSpace.large, CSpace.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data.icon != null)
                    Container(
                      padding: const EdgeInsets.only(top: CSpace.small, right: CSpace.small),
                      child: SvgPicture.asset(
                        data.icon ?? '',
                        semanticsLabel: data.label,
                        width: CFontSize.headline3,
                        color: CColor.black.shade400,
                      ),
                    ),
                  if (data.label != '')
                    Container(
                      margin: const EdgeInsets.only(top: CSpace.small),
                      child: Text(
                        '${data.label}  ',
                        style: const TextStyle(fontSize: CFontSize.paragraph1, fontWeight: FontWeight.w600),
                      ),
                    ),
                  if (data.dataType != DataType.column)
                    Expanded(
                      child: Container(
                        alignment: data.label != '' ? Alignment.centerRight : Alignment.centerLeft,
                        child: Content(
                          data: data,
                        ),
                      ),
                    )
                ],
              ),
              if (data.dataType == DataType.column)
                data.value != ''
                    ? Text(
                        data.value,
                        style: const TextStyle(fontSize: CFontSize.paragraph1),
                      )
                    : Container(
                        height: 30,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '(${'widgets.list.details.Empty'.tr()})',
                          style: TextStyle(color: CColor.black.shade300),
                        ),
                      ),
            ],
          ),
        );
    }
  }
}

class Content extends StatelessWidget {
  final MFormItem data;

  const Content({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.child != null) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: CSpace.small),
        child: data.child!,
      );
    }
    if (data.value == '') {
      return SizedBox(
        height: CHeight.medium / 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: CHeight.mediumSmall / 2,
              alignment: Alignment.centerLeft,
              child: Text(
                '(${'widgets.list.details.Empty'.tr()})',
                style: TextStyle(
                  color: CColor.black.shade300,
                ),
              ),
            )
          ],
        ),
      );
    }
    if (data.dataType == DataType.button || data.dataType == DataType.phone) {
      String? title;
      switch (data.dataType) {
        case DataType.phone:
          title = Convert.phoneNumber(data.value);
          break;
        default:
      }
      return Container(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onLongPress: () {
            if (data.dataType == DataType.phone) {
              Clipboard.setData(ClipboardData(text: data.value));
              UDialog().showSuccess(text: 'widgets.list.details.Phone number copied'.tr());
            }
          },
          child: ElevatedButton(
              onPressed: () async {
                if (data.dataType == DataType.phone) {
                  await launchUrl(Uri(
                    scheme: 'tel',
                    path: data.value,
                  ));
                  return;
                }
                if (data.onTap != null) {
                  data.onTap!(context, data.dataType, data.value);
                }
              },
              child: title ?? data.value),
        ),
      );
    }
    if (data.dataType == DataType.status) {
      Color color = CColor.statusColor(data.value);
      String convertStatus = CPref.statusTitle(data.value);
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 20,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(vertical: 7.5),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(0)),
            child: Text(
              convertStatus,
              style: const TextStyle(
                color: Colors.white,
                fontSize: CFontSize.paragraph1 / 0.8,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }
    return Container(
      margin: const EdgeInsets.only(top: CSpace.small),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Text(
              data.value,
              style: const TextStyle(fontSize: CFontSize.paragraph2),
              textAlign: TextAlign.right,
            ),
          ),
          data.dataType == DataType.copy
              ? Container(
                  height: 18,
                  width: 25,
                  margin: const EdgeInsets.only(left: 3, bottom: 8),
                  child: GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: data.value));
                        UDialog().showSuccess(text: 'widgets.list.details.Successfully copied'.tr());
                      },
                      child: Icon(
                        Icons.copy,
                        size: 18,
                        color: CColor.primary,
                      )),
                )
              : const SizedBox(height: CHeight.medium / 2)
        ],
      ),
    );
  }
}
