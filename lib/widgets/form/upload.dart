import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '/constants/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';
import '/widgets/index.dart';

class WUpload extends StatefulWidget {
  final String label;
  final String docType;
  final bool space;
  final int maxQuantity;
  final int minQuantity;
  final ValueChanged onChanged;
  final List? list;

  const WUpload({
    Key? key,
    this.label = '',
    this.space = true,
    this.docType = 'post',
    required this.onChanged,
    this.maxQuantity = 1,
    this.minQuantity = 1,
    this.list,
  }) : super(key: key);

  @override
  WUploadState createState() => WUploadState();
}

class WUploadState extends State<WUpload> {
  bool isVideo = false;

  final ImagePicker _picker = ImagePicker();

  void _onImageButtonPressed(
      {required ImageSource source,
      required BuildContext context,
      bool isMultiImage = false,
      required BlocC cubit}) async {
    if (isVideo) {
      // final XFile? file = await _picker.pickVideo(source: source, maxDuration: const Duration(seconds: 10));
    } else if (isMultiImage) {
      final List<XFile> pickedFileList = await _picker.pickMultiImage();
      await showConfirmImage(imageFileList: pickedFileList, isMultiImage: isMultiImage, cubit: cubit);
    } else {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
      );
      if (pickedFile != null) {
        await showConfirmImage(imageFileList: [pickedFile], isMultiImage: isMultiImage, cubit: cubit);
      }
    }
  }

  Future<void> showConfirmImage(
      {required List<XFile>? imageFileList, required bool isMultiImage, required BlocC cubit}) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0),
          actionsPadding: const EdgeInsets.symmetric(vertical: 0.0),
          contentPadding: const EdgeInsets.all(0),
          content: SizedBox(
            width: 250.0,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMultiImage ? 2 : 1,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 1.15,
              ),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: imageFileList!.length,
              itemBuilder: (context, index) => ExtendedImage.file(
                File(imageFileList[index].path),
                fit: BoxFit.cover,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('widgets.form.upload.Cancel'.tr()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'widgets.form.upload.Upload'.tr(),
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              onPressed: () async {
                cubit.setStatus(status: AppStatus.inProcess);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                dynamic api = RepositoryProvider.of<Api>(context);
                List list = cubit.state.data.content!;

                for (var item in imageFileList) {
                  MUpload data = await api.postUploadPhysicalBlob(file: item, docType: widget.docType);
                  list.add(data);
                }
                cubit.setData(
                    data: MData.fromJson({
                  'page': 1,
                  'totalPages': list.length,
                  'size': list.length,
                  'numberOfElements': list.length,
                  'totalElements': list.length,
                  'content': list
                }, null));
                widget.onChanged(list.map((e) => e.toJson()));
              },
            ),
          ],
        );
      },
    );
  }

  void _showModal(context, BlocC cubit) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: CSpace.large),
          child: Wrap(
            children: [
              listTile(
                  svg: 'assets/svgs/image.svg',
                  name: 'widgets.form.upload.Select image from gallery'.tr(),
                  onTap: () {
                    isVideo = false;
                    _onImageButtonPressed(source: ImageSource.gallery, context: context, cubit: cubit);
                  }),
              listTile(
                  svg: 'assets/svgs/multiple-image.svg',
                  name: 'widgets.form.upload.Select multiple images from gallery'.tr(),
                  onTap: () {
                    isVideo = false;
                    _onImageButtonPressed(
                        source: ImageSource.gallery, context: context, isMultiImage: true, cubit: cubit);
                  }),
              listTile(
                  svg: 'assets/svgs/camera.svg',
                  name: 'widgets.form.upload.Take a photo'.tr(),
                  onTap: () {
                    isVideo = false;
                    _onImageButtonPressed(source: ImageSource.camera, context: context, cubit: cubit);
                  }),
              listTile(
                  svg: 'assets/svgs/video.svg',
                  name: 'widgets.form.upload.Select Video from gallery'.tr(),
                  onTap: () {
                    isVideo = true;
                    _onImageButtonPressed(source: ImageSource.gallery, context: context, cubit: cubit);
                  }),
              listTile(
                  svg: 'assets/svgs/camera-2.svg',
                  name: 'widgets.form.upload.Shoot a movie'.tr(),
                  onTap: () {
                    isVideo = true;
                    _onImageButtonPressed(source: ImageSource.camera, context: context, cubit: cubit);
                  }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        if (widget.list != null) {
          return BlocC()
            ..setData(
                data: MData.fromJson({
              'page': 1,
              'totalPages': widget.list!.length,
              'size': widget.list!.length,
              'numberOfElements': widget.list!.length,
              'totalElements': widget.list!.length,
              'content': widget.list
            }, null));
        }
        return BlocC();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: CSpace.small),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.label != ''
                    ? Text(
                        widget.label,
                        style: TextStyle(
                          color: CColor.black,
                          fontSize: CFontSize.paragraph1,
                        ),
                      )
                    : Container(),
                Row(
                  children: [
                    SizedBox(
                        width: CHeight.mediumSmall,
                        height: CHeight.mediumSmall,
                        child: BlocBuilder<BlocC, BlocS>(
                          builder: (context, state) {
                            return ElevatedButton(
                              style: state.status == AppStatus.show ? CStyle.buttonDanger : CStyle.buttonWhite,
                              onPressed: () {
                                context.read<BlocC>().setStatus(
                                    status: state.status == AppStatus.show ? AppStatus.init : AppStatus.show);
                              },
                              child: state.status == AppStatus.show ? CIcon.removeWhite : CIcon.remove,
                            );
                          },
                        )),
                    const SizedBox(
                      width: CSpace.medium,
                      child: null,
                    ),
                    BlocBuilder<BlocC, BlocS>(
                        builder: (context, state) =>SizedBox(
                            width: CHeight.mediumSmall,
                            height: CHeight.mediumSmall,
                            child: ElevatedButton(
                                style: CStyle.buttonWhite,
                                onPressed: () => _showModal(context, context.read<BlocC>()),
                                child: CIcon.upload))),
                  ],
                )
              ],
            ),
            BlocBuilder<BlocC, BlocS>(
                builder: (context, state) => state.data.content!.isNotEmpty
                    ? GridView.builder(
                        physics: const ScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          childAspectRatio: 1.15,
                        ),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: state.data.content!.length,
                        itemBuilder: (context, index) => Container(
                          color: CColor.black,
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: AlignmentDirectional.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) => ExtendedImageGesturePageView.builder(
                                            controller: ExtendedPageController(
                                              initialPage: index,
                                              pageSpacing: 0,
                                            ),
                                            preloadPagesCount: 0,
                                            itemCount: state.data.content!.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Stack(
                                                clipBehavior: Clip.none,
                                                alignment: AlignmentDirectional.center,
                                                children: [
                                                  ExtendedImage.network(
                                                    state.data.content![index].fileUrl,
                                                    fit: BoxFit.contain,
                                                    mode: ExtendedImageMode.gesture,
                                                    initGestureConfigHandler: (ExtendedImageState state) =>
                                                        GestureConfig(
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
                                    state.data.content![index].fileUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              state.status == AppStatus.show
                                  ? Positioned(
                                      right: -CSpace.small,
                                      top: -CSpace.small,
                                      width: CHeight.medium / 2,
                                      height: CHeight.medium / 2,
                                      child: InkWell(
                                        onTap: () {
                                          List list = context.read<BlocC>().state.data.content!;
                                          list.removeAt(index);
                                          context.read<BlocC>().setData(
                                              data: MData.fromJson({
                                                'page': 1,
                                                'totalPages': list.length,
                                                'size': list.length,
                                                'numberOfElements': list.length,
                                                'totalElements': list.length,
                                                'content': list
                                              }, null),
                                              status: AppStatus.show);
                                          widget.onChanged(list.map((e) => e.toJson()));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(CSpace.small),
                                          decoration: BoxDecoration(
                                            color: CColor.danger,
                                            borderRadius: const BorderRadius.all(Radius.circular(CSpace.large)),
                                          ),
                                          child: Wrap(
                                            alignment: WrapAlignment.center,
                                            children: [CIcon.close],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox()),
            BlocBuilder<BlocC, BlocS>(
                builder: (context, state) => state.status == AppStatus.inProcess
                    ? Center(
                        child: progressIndicator(),
                      )
                    : const SizedBox()),
            SizedBox(height: widget.space ? CSpace.large : 0),
          ],
        ),
      ),
    );
  }
}
