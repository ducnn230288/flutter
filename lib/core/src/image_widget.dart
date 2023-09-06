import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';

Widget imageNetwork({
  required String url,
  BoxFit fit = BoxFit.cover,
  Widget? placeHolder,
  double? width,
  double? height,
  BorderRadius? borderRadius,
  bool showFullScreen = true,
}) {
  Widget child = SizedBox(
    width: width,
    height: height,
    child: placeHolder ?? CIcon.placeholderImage,
  );
  child = InkWell(
    splashColor: CColor.primary.shade100,
    onTap: showFullScreen
        ? () {
            rootNavigatorKey.currentState!.push(MaterialPageRoute(
                builder: (_) => Scaffold(
                      appBar: appBar(
                        title: '',
                        actions: [downloadImage(url: url)],
                      ),
                      backgroundColor: CColor.black,
                      body: BlocProvider(
                        create: (context) => BlocC(),
                        child: Builder(builder: (context) {
                          final cubit = context.read<BlocC>();
                          cubit.saved(name: 'width', value: CSpace.width);
                          cubit.saved(name: 'opacity', value: 1.0);
                          return InteractiveViewer(
                            maxScale: 5.0,
                            minScale: 1.0,
                            child: Center(
                              child: Hero(
                                tag: url,
                                child: Draggable(
                                  maxSimultaneousDrags: 1,
                                  axis: Axis.vertical,
                                  onDragUpdate: (details) {
                                    final double y = details.globalPosition.dy;
                                    final double space = CSpace.height / 2;
                                    final double ratio = 1 - (y >= space ? (y - space) / space : (space - y) / space);
                                    cubit.addValue(value: ratio, name: 'opacity');
                                  },
                                  onDragEnd: (_) {
                                    if (cubit.state.value['opacity'] <= 0.6) {
                                      context.pop();
                                    }
                                  },
                                  feedback: BlocProvider.value(
                                    value: BlocProvider.of<BlocC>(context),
                                    child: BlocBuilder<BlocC, BlocS>(
                                      builder: (context, state) {
                                        return Transform.scale(
                                          scale: state.value['opacity'],
                                          child: Opacity(
                                            opacity: state.value['opacity'],
                                            child: ExtendedImage.network(url, fit: fit, width: CSpace.width),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  childWhenDragging: Container(),
                                  child: ExtendedImage.network(url, fit: fit),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    )));
          }
        : null,
    child: Hero(
      tag: url,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: ExtendedImage.network(url, fit: fit, width: width, height: height),
      ),
    ),
  );
  return child;
}

Widget listImageNetwork(
    {required String url,
    required List<MUpload> listUrl,
    BoxFit fit = BoxFit.cover,
    Widget? placeHolder,
    double? width,
    double? height,
    BorderRadius? borderRadius,
    Function(String description, int index)? onChangedDescription}) {
  Widget child = SizedBox(
    width: width,
    height: height,
    child: placeHolder ?? CIcon.placeholderImage,
  );
  child = InkWell(
    splashColor: CColor.primary.shade100,
    onTap: () {
      PageController controller = PageController();
      String image = url;
      int idx = 0;
      for (int i = 0; i < listUrl.length; i++) {
        if (image == listUrl[i].fileUrl) {
          controller = PageController(initialPage: i);
          idx = i + 1;
          break;
        }
      }
      rootNavigatorKey.currentState!.push(MaterialPageRoute(
          builder: (_) => BlocProvider(
                create: (context) => BlocC(),
                child: Builder(builder: (context) {
                  final cubit = context.read<BlocC>();
                  cubit.saved(name: 'index', value: idx);
                  return Scaffold(
                      backgroundColor: CColor.black,
                      appBar: appBar(
                        title: '',
                        actions: [downloadImage(url: image)],
                      ),
                      body: SafeArea(
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            PageView.builder(
                              itemCount: listUrl.length,
                              controller: controller,
                              itemBuilder: (_, index) => InteractiveViewer(
                                maxScale: 5.0,
                                minScale: 1.0,
                                child: Center(
                                  child: Hero(
                                    tag: url,
                                    child: Draggable(
                                      maxSimultaneousDrags: 1,
                                      affinity: Axis.vertical,
                                      axis: Axis.vertical,
                                      onDragUpdate: (details) {
                                        final double y = details.globalPosition.dy;
                                        final double space = CSpace.height / 2;
                                        final double ratio =
                                            1 - (y >= space ? (y - space) / space : (space - y) / space);
                                        cubit.addValue(value: ratio, name: 'opacity');
                                      },
                                      onDragEnd: (_) {
                                        if (cubit.state.value['opacity'] <= 0.6) {
                                          context.pop();
                                        }
                                      },
                                      feedback: BlocProvider.value(
                                        value: BlocProvider.of<BlocC>(context),
                                        child: BlocBuilder<BlocC, BlocS>(
                                          builder: (context, state) {
                                            return Transform.scale(
                                              scale: state.value['opacity'],
                                              child: Opacity(
                                                opacity: state.value['opacity'],
                                                child: ExtendedImage.network(
                                                  listUrl[index].fileUrl,
                                                  fit: fit,
                                                  width: CSpace.width,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      childWhenDragging: Container(),
                                      child: ExtendedImage.network(
                                        listUrl[index].fileUrl,
                                        fit: fit,
                                        width: CSpace.width,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              onPageChanged: (index) {
                                context.read<BlocC>().addValue(value: index + 1, name: 'index');
                                image = listUrl[index].fileUrl;
                              },
                            ),
                            Container(
                              padding: const EdgeInsets.all(CSpace.small / 2),
                              margin: const EdgeInsets.only(bottom: CSpace.mediumSmall),
                              color: CColor.black.withOpacity(0.7),
                              child: BlocBuilder<BlocC, BlocS>(
                                builder: (context, state) {
                                  return Text(
                                    '${state.value['index']}/${listUrl.length}',
                                    style: const TextStyle(color: Colors.white),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (onChangedDescription != null)
                                    Container(
                                      width: 95,
                                      height: 35,
                                      margin: const EdgeInsets.only(bottom: CSpace.superSmall, right: CSpace.small),
                                      child: TextButton(
                                        style: ButtonStyle(
                                            shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(CSpace.small)),
                                            ),
                                            backgroundColor: MaterialStatePropertyAll(CColor.black.shade300)),
                                        onPressed: () => UDialog().showForm(
                                          title: 'Thêm chú thích cho ảnh',
                                          formItem: [
                                            MFormItem(
                                              hintText: 'Chú thích',
                                              name: 'description',
                                              maxLines: 4,
                                              value:
                                                  listUrl[context.read<BlocC>().state.value['index'] - 1].description,
                                            )
                                          ],
                                          onSubmit: (value) {
                                            final cubit = context.read<BlocC>();
                                            int index = cubit.state.value['index'];
                                            cubit.addValue(value: value['description'], name: 'description$index');
                                            onChangedDescription(value['description'], index - 1);
                                            rootNavigatorKey.currentState!.context.pop();
                                          },
                                          api: (_, __, ___, ____) {},
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            BlocBuilder<BlocC, BlocS>(
                                              builder: (context, state) {
                                                final int index = state.value['index'];
                                                return Icon(
                                                  state.value['description$index'] == null &&
                                                          listUrl[index - 1].description == ''
                                                      ? Icons.note_add
                                                      : Icons.edit,
                                                  color: Colors.white,
                                                  size: CFontSize.footnote,
                                                );
                                              },
                                            ),
                                            const HSpacer(CSpace.small),
                                            const Text(
                                              'Chú thích',
                                              style: TextStyle(fontSize: CFontSize.footnote, color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  BlocBuilder<BlocC, BlocS>(
                                    builder: (context, state) {
                                      final int index = state.value['index'];
                                      if (state.value['description${state.value['index']}'] == null &&
                                          listUrl[state.value['index'] - 1].description == '') {
                                        return Container();
                                      }
                                      return Container(
                                        width: CSpace.width,
                                        padding: const EdgeInsets.all(CSpace.large),
                                        color: CColor.black.withOpacity(0.7),
                                        child: DescriptionTextWidget(
                                          text: state.value['description$index'] ?? listUrl[index - 1].description,
                                          style: const TextStyle(fontSize: CFontSize.footnote, color: Colors.white),
                                          trim: 200,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ));
                }),
              )));
    },
    child: Hero(
        tag: url,
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: ExtendedImage.network(url, fit: fit, width: width, height: height),
        )),
  );
  return child;
}

downloadImage({required String url}) => GestureDetector(
      onTap: () async {
        USnackBar.smallSnackBar(title: 'Đang tải ảnh về...', isInfiniteTime: true);
        var response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
        var check = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data),
            quality: 100, name: DateTime.now().toIso8601String());
        USnackBar.hideSnackBar();
        if (check['isSuccess'] && response.statusCode == 200) {
          USnackBar.smallSnackBar(title: 'Tải ảnh về thư viện thành công', width: 190);
        }
      },
      child: const Padding(
        padding: EdgeInsets.only(top: 8, right: CSpace.medium),
        child: Text(
          'Tải xuống',
          style: TextStyle(fontSize: CFontSize.body, color: Colors.white),
        ),
      ),
    );
