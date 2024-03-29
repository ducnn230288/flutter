import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';

class FUpload<T> extends FormField<List> {
  FUpload({
    super.key,
    required FormFieldSetter<List> onChanged,
    required String name,
    required bool required,
    UploadType uploadType = UploadType.multiple,
    required List list,
    Function? onDelete,
    String label = '',
    bool space = true,
    int maxQuantity = 1,
    int minQuantity = 1,
    String docType = 'post',
    String? prefix,
    int? maxCount,
  }) : super(
            onSaved: onChanged,
            validator: (value) {
              if (required && (value == null || value.isEmpty)) {
                return 'widgets.form.input.Please choose file'.tr();
              }
              return null;
            },
            initialValue: list,
            builder: (FormFieldState<List> state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WUpload(
                      onDelete: onDelete,
                      uploadType: uploadType,
                      list: list,
                      label: label,
                      space: space,
                      maxQuantity: maxQuantity,
                      minQuantity: minQuantity,
                      docType: docType,
                      prefix: prefix,
                      required: required,
                      maxCount: maxCount,
                      onChanged: (dynamic value) {
                        state.didChange(value);
                        state.validate();
                        onChanged(value);
                      }),
                  state.hasError
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: CSpace.xl),
                          child: Text(
                            state.errorText!,
                            style: TextStyle(fontSize: CFontSize.xs, color: CColor.danger),
                          ),
                        )
                      : const SizedBox()
                ],
              );
            });
}

class WUpload extends StatefulWidget {
  final String label;
  final String docType;
  final String? prefix;
  final bool required;
  final bool space;
  final bool isDescription;
  final int maxQuantity;
  final int minQuantity;
  final ValueChanged onChanged;
  final Function? onDelete;
  final Function? onAdd;
  final List? list;
  final int? maxCount;
  final UploadType uploadType;

  const WUpload({
    super.key,
    this.label = '',
    this.space = true,
    this.isDescription = true,
    this.docType = 'post',
    this.prefix,
    required this.onChanged,
    this.onDelete,
    this.onAdd,
    this.maxQuantity = 1,
    this.minQuantity = 1,
    this.list,
    this.uploadType = UploadType.multiple,
    this.maxCount,
    this.required = true,
  });

  @override
  WUploadState createState() => WUploadState();
}

class WUploadState extends State<WUpload> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        if (widget.list != null) {
          return BlocC<MUpload>()
            ..setData(
                data: MData<MUpload>.fromJson({
              'page': 1,
              'totalPages': widget.list!.length,
              'size': widget.list!.length,
              'numberOfElements': widget.list!.length,
              'totalElements': widget.list!.length,
              'content': widget.list
            }, MUpload.fromJson));
        }
        return BlocC<MUpload>();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.label != '' ? BlocBuilder<BlocC<MUpload>, BlocS<MUpload>>(
            builder: (context, state) => Row(
              children: [
                Flexible(
                  child: Text(
                    "${widget.label}${widget.maxCount != null ? " (${state.data.content.length}/${widget.maxCount})" : ''}",
                    style: const TextStyle(
                      fontSize: CFontSize.lg,
                      fontWeight: FontWeight.w600,
                      height: 22 / CFontSize.base,
                    ),
                  ),
                ),
                if (widget.required)
                  Container(
                    height: 19,
                    margin: const EdgeInsets.only(left: CSpace.xs),
                    child: Text('*', style: TextStyle(color: CColor.danger, fontSize: 20)),
                  )
              ],
            ),
          ) : const SizedBox(height: CSpace.sm,),
          BlocConsumer<BlocC<MUpload>, BlocS<MUpload>>(listener: (_, state) {
            if (state.status == AppStatus.inProcess) {
              USnackBar.smallSnackBar(title: 'Đang tải ảnh lên...', isInfiniteTime: true);
            } else {
              USnackBar.hideSnackBar();
            }
          }, builder: (context, state) {
            const int count = 4;
            final double imageSize = CSpace.width / count;
            List<MUpload> listImage =
                (state.data.content).map((dynamic e) => MUpload.fromJson(jsonDecode(jsonEncode(e)))).toList();
            return GridView.builder(
                padding: const EdgeInsets.symmetric(vertical: CSpace.base),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: count,
                  crossAxisSpacing: CSpace.xl,
                  mainAxisSpacing: CSpace.xl,
                ),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: state.data.content.length + 1,
                itemBuilder: (_, index) {
                  if (index == state.data.content.length && widget.maxQuantity > 0 && widget.maxQuantity == state.data.content.length) return Container();
                  if (index == state.data.content.length) return addItem(context);
                  return Stack(
                    clipBehavior: Clip.none,
                    alignment: AlignmentDirectional.center,
                    children: [
                      listImageNetwork(
                        height: imageSize,
                        width: imageSize,
                        listUrl: listImage,
                        url: listImage[index].fileUrl,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(CSpace.sm),
                        onChangedDescription: !widget.isDescription
                            ? null
                            : (description, idx) {
                                final cubit = context.read<BlocC<MUpload>>();
                                listImage[idx] = listImage[idx].copyWith(description: description);
                                cubit.setData(
                                    data: MData.fromJson({
                                  'page': 1,
                                  'totalPages': listImage.length,
                                  'size': listImage.length,
                                  'numberOfElements': listImage.length,
                                  'totalElements': listImage.length,
                                  'content': listImage
                                }, null));
                                widget.onChanged(listImage.map((e) => e.toJson()).toList());
                              },
                      ),
                      Positioned(
                        right: -CSpace.sm,
                        top: -CSpace.sm,
                        width: CHeight.xl2 / 2,
                        height: CHeight.xl2 / 2,
                        child: InkWell(
                          onTap: () => UDialog().showConfirm(
                              title: 'Xóa ảnh đã chọn',
                              text: 'Bạn có chắc muốn xóa ảnh hiện tại không?',
                              btnOkOnPress: () {
                                List<MUpload> list = context.read<BlocC<MUpload>>().state.data.content;
                                if (widget.onDelete != null) widget.onDelete!(list[index]);
                                list.removeAt(index);
                                context.read<BlocC<MUpload>>().setData(
                                    data: MData(
                                        page: 1,
                                        totalPages: list.length,
                                        size: list.length,
                                        numberOfElements: list.length,
                                        totalElements: list.length,
                                        content: list),
                                    status: AppStatus.show);
                                widget.onChanged(list.map((e) => e.toJson()).toList());
                                context.pop();
                              }),
                          child: Container(
                            padding: const EdgeInsets.all(CSpace.sm),
                            decoration: BoxDecoration(
                              color: CColor.danger,
                              borderRadius: const BorderRadius.all(Radius.circular(CSpace.sm)),
                            ),
                            child: CIcon.closeWhite,
                          ),
                        ),
                      )
                    ],
                  );
                });
          }),
          SizedBox(height: widget.space ? CSpace.sm : 0),
        ],
      ),
    );
  }

  Widget addItem(BuildContext context) {
    return BlocBuilder<BlocC<MUpload>, BlocS<MUpload>>(
      builder: (context, state) => (state.data.content.isEmpty && widget.uploadType == UploadType.single) ||
              widget.uploadType == UploadType.multiple
          ? (widget.maxCount == null || (state.data.content.length) < (widget.maxCount ?? 0))
              ? InkWell(
                  splashColor: CColor.primary.shade100,
                  onTap: () => _showModal(context),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(CSpace.sm),
                      color: CColor.black.shade200.withOpacity(0.4),
                    ),
                    child: Icon(
                      Icons.add,
                      color: CColor.black.shade400.withOpacity(0.8),
                      size: CFontSize.xl4 * 1.5,
                    ),
                  ),
                )
              : Container()
          : Container(),
    );
  }

  bool isVideo = false;

  final ImagePicker _picker = ImagePicker();

  void _onImageButtonPressed({
    required ImageSource source,
    required BuildContext context,
    bool isMultiImage = false,
  }) async {
    if (isVideo) {
      // final XFile? file = await _picker.pickVideo(source: source, maxDuration: const Duration(seconds: 10));
    } else if (isMultiImage) {
      final List<XFile> pickedFileList = await _picker.pickMultiImage();
      if (pickedFileList.isNotEmpty) {
        await showConfirmImage(imageFileList: pickedFileList, isMultiImage: isMultiImage, context: context);
      }
    } else {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        await addImage(imageFileList: [pickedFile], isMultiImage: isMultiImage, context: context);
      }
    }
  }

  Future<void> showConfirmImage({
    required List<XFile>? imageFileList,
    required bool isMultiImage,
    required BuildContext context,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0),
          actionsPadding: const EdgeInsets.symmetric(vertical: 0.0),
          contentPadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CSpace.xs)),
          content: SizedBox(
            width: CSpace.width * 0.9,
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
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: index == 0 ? const Radius.circular(CSpace.xs) : const Radius.circular(0),
                  topRight: index == 1 ? const Radius.circular(CSpace.xs) : const Radius.circular(0),
                ),
                child: ExtendedImage.file(File(imageFileList[index].path), fit: BoxFit.cover),
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
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                onPressed: () => addImage(imageFileList: imageFileList, isMultiImage: isMultiImage, context: context)),
          ],
        );
      },
    );
  }

  Future<void> addImage({
    required List<XFile>? imageFileList,
    required bool isMultiImage,
    required BuildContext context,
  }) async {
    Navigator.of(context).pop();
    final BlocC<MUpload> cubit = context.read<BlocC<MUpload>>();
    cubit.setStatus(status: AppStatus.inProcess);
    if (isMultiImage) {
      Navigator.of(context).pop();
    }
    final api = RepositoryProvider.of<Api>(context);
    List list = cubit.state.data.content;
    int count = list.length;
    for (var item in imageFileList!) {
      if (widget.maxCount != null && count >= widget.maxCount!) {
        break;
      }
      MUpload? data = await api.postUploadPhysicalBlob(file: item, prefix: widget.prefix ?? widget.docType, obj: {
        'docType': widget.docType,
        'docTypeName': widget.label,
        'prefix': widget.prefix ?? widget.docType,
      });
      if (data != null) {
        if (widget.onAdd != null) widget.onAdd!(data, cubit);
        list.add(data);
        count++;
      }
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
    widget.onChanged(list.map((e) => e.toJson()).toList());
  }

  void _showModal(context) {
    FocusScope.of(context).unfocus();
    showModalBottomSheet<void>(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: CSpace.sm),
          child: Wrap(
            children: [
              listTile(
                  svg: 'assets/svgs/upload/image.svg',
                  name: 'widgets.form.upload.Select image from gallery'.tr(),
                  onTap: () {
                    isVideo = false;
                    _onImageButtonPressed(source: ImageSource.gallery, context: context);
                  }),
              if (widget.uploadType == UploadType.multiple)
                listTile(
                    svg: 'assets/svgs/upload/multiple-image.svg',
                    name: 'widgets.form.upload.Select multiple images from gallery'.tr(),
                    onTap: () {
                      isVideo = false;
                      _onImageButtonPressed(source: ImageSource.gallery, context: context, isMultiImage: true);
                    }),
              listTile(
                  svg: 'assets/svgs/upload/camera.svg',
                  name: 'widgets.form.upload.Take a photo'.tr(),
                  onTap: () {
                    isVideo = false;
                    _onImageButtonPressed(source: ImageSource.camera, context: context);
                  }),
              // listTile(
              //     svg: 'assets/svgs/upload/video.svg',
              //     name: 'widgets.form.upload.Select Video from gallery'.tr(),
              //     onTap: () {
              //       isVideo = true;
              //       _onImageButtonPressed(source: ImageSource.gallery, context: context);
              //     }),
              // listTile(
              //     svg: 'assets/svgs/upload/camera-2.svg',
              //     name: 'widgets.form.upload.Shoot a movie'.tr(),
              //     onTap: () {
              //       isVideo = true;
              //       _onImageButtonPressed(source: ImageSource.camera, context: context);
              //     }),
            ],
          ),
        );
      },
    );
  }
}
