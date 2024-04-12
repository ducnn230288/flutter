import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

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
                builder: (_) => BlocProvider(
                      create: (context) => BlocC(),
                      child: Builder(builder: (ctx) {
                        return Scaffold(
                          appBar: appBar(
                            title: '',
                            actions: [
                              _downloadImage(
                                url: url,
                                downloadProgress: (int total, int downloaded, double progress, fileName) {},
                              )
                            ],
                          ),
                          backgroundColor: CColor.black,
                          body: BlocProvider(
                            create: (context) => BlocC(),
                            child: Builder(builder: (context) {
                              final cubit = context.read<BlocC>();
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
                                                child: ExtendedImage.network(url, fit: fit, width: CSpace.width),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      childWhenDragging: Container(),
                                      child: ExtendedImage.network(url, fit: fit, width: CSpace.width),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      }),
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
                child: Builder(builder: (ctx) {
                  return Scaffold(
                      backgroundColor: CColor.black,
                      appBar: appBar(
                        title: '',
                        actions: [
                          _downloadImage(
                              url: image,
                              downloadProgress: (total, downloaded, progress, fileName) {
                                ctx.read<BlocC>().setValue(value: {
                                  'total': total,
                                  'downloaded': downloaded,
                                  'progress': progress,
                                  'visible': progress < 100,
                                  'fileName': fileName,
                                });
                              })
                        ],
                      ),
                      body: SafeArea(
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            BlocProvider(
                              create: (context) => BlocC(),
                              child: Builder(builder: (context) {
                                final cubit = context.read<BlocC>();
                                cubit.saved(name: 'index', value: idx);
                                return Stack(
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
                                      padding: const EdgeInsets.all(CSpace.sm / 2),
                                      margin: const EdgeInsets.only(bottom: CSpace.base),
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
                                              margin:
                                                  const EdgeInsets.only(bottom: CSpace.xs, right: CSpace.sm),
                                              child: TextButton(
                                                style: ButtonStyle(
                                                    shape: MaterialStatePropertyAll(
                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(CSpace.sm)),
                                                    ),
                                                    backgroundColor: MaterialStatePropertyAll(CColor.black.shade300)),
                                                onPressed: () => UDialog().showForm(
                                                  title: 'Thêm chú thích cho ảnh',
                                                  formItem: [
                                                    MFormItem(
                                                      hintText: 'Chú thích',
                                                      name: 'description',
                                                      maxLines: 4,
                                                      value: listUrl[context.read<BlocC>().state.value['index'] - 1]
                                                          .description,
                                                    )
                                                  ],
                                                  onSubmit: (value) {
                                                    final cubit = context.read<BlocC>();
                                                    int index = cubit.state.value['index'];
                                                    cubit.addValue(
                                                        value: value['description'], name: 'description$index');
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
                                                          size: CFontSize.xs,
                                                        );
                                                      },
                                                    ),
                                                    const HSpacer(CSpace.sm),
                                                    const Text(
                                                      'Chú thích',
                                                      style:
                                                          TextStyle(fontSize: CFontSize.xs, color: Colors.white),
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
                                                padding: const EdgeInsets.all(CSpace.xl3),
                                                color: CColor.black.withOpacity(0.7),
                                                child: DescriptionTextWidget(
                                                  text: state.value['description$index'] ??
                                                      listUrl[index - 1].description,
                                                  style: const TextStyle(
                                                      fontSize: CFontSize.xs, color: Colors.white),
                                                  trim: 200,
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                            BlocSelector<BlocC, BlocS, bool>(
                              selector: (state) => state.value['visible'] ?? false,
                              builder: (context, state) {
                                if (!state) return Container();
                                return Container(
                                  padding: const EdgeInsets.all(CSpace.xl3),
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          BlocSelector<BlocC, BlocS, String>(
                                            selector: (state) => state.value['fileName'] ?? '',
                                            builder: (context, state) {
                                              return Expanded(child: Text(state));
                                            },
                                          ),
                                          const HSpacer(2 * CSpace.xl5),
                                          BlocBuilder<BlocC, BlocS>(
                                            builder: (context, state) {
                                              if (state.value['progress'] == null) return Container();
                                              final value = state.value;
                                              final String unit = value['total'] >= 1000000 ? 'MB' : 'KB';
                                              final int dDownloaded = value['downloaded'];
                                              final int dTotal = value['total'];
                                              final String downloaded =
                                                  (dDownloaded >= 1000000 ? dDownloaded / 1000000 : dDownloaded / 1000)
                                                      .toStringAsFixed(2);
                                              final String total =
                                                  (dTotal >= 1000000 ? dTotal / 1000000 : dTotal / 1000)
                                                      .toStringAsFixed(2);
                                              final String progress = value['progress'].toStringAsFixed(2);
                                              return Text('$downloaded $unit/$total $unit  $progress%');
                                            },
                                          ),
                                          const HSpacer(CSpace.base),
                                          Icon(Icons.download_for_offline,
                                              size: CSpace.xl5, color: CColor.primary),
                                        ],
                                      ),
                                      const VSpacer(CSpace.xl3),
                                      Stack(
                                        children: [
                                          Container(
                                            height: CSpace.sm,
                                            width: CSpace.width,
                                            color: CColor.blue.shade300,
                                          ),
                                          BlocSelector<BlocC, BlocS, double>(
                                            selector: (state) => state.value['progress'],
                                            builder: (context, state) {
                                              return Container(
                                                height: CSpace.sm,
                                                width: CSpace.width * (state / 100),
                                                color: CColor.blue,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
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

_downloadImage(
        {required String url,
        required Function(int total, int downloaded, double progress, String name) downloadProgress}) =>
    InkWell(
      splashColor: CColor.primary.shade100,
      onTap: () async {
        try {
          await _requestPermission();
          final String fileName = 'IMAGE_${Random().nextInt(99999)}';
          await _download(url, (total, downloaded, progress) => downloadProgress(total, downloaded, progress, fileName))
              .then((imageBytes) async {
            var check = await ImageGallerySaver.saveImage(imageBytes, quality: 100, name: fileName);
            if (check['isSuccess']) {
              USnackBar.smallSnackBar(title: 'Tải ảnh về thư viện thành công', width: 190);
            }
          }).catchError((error) {
            USnackBar.smallSnackBar(title: 'Tải ảnh không thành công !!!', width: 190);
            AppConsole.dump(error, name: 'ERROR');
          });
        } catch (e) {
          USnackBar.smallSnackBar(title: 'Tải ảnh không thành công !!!', width: 190);
          AppConsole.dump(e.toString());
        }
      },
      child: const Padding(
        padding: EdgeInsets.only(top: 8, right: CSpace.sm),
        child: Text(
          'Tải xuống',
          style: TextStyle(fontSize: CFontSize.base, color: Colors.white),
        ),
      ),
    );

Future<Uint8List> _download(String url, Function(int total, int downloaded, double progress) downloadProgress) {
  final completer = Completer<Uint8List>();
  final client = http.Client();
  final request = http.Request('GET', Uri.parse(url));
  final response = client.send(request);

  int downloadedBytes = 0;
  List<List<int>> chunkList = [];

  response.asStream().listen((event) {
    event.stream.listen(
      (chunk) {
        final contentLength = event.contentLength ?? 0;
        final progress = (downloadedBytes / contentLength) * 100;
        downloadProgress(contentLength, downloadedBytes, progress);
        chunkList.add(chunk);
        downloadedBytes += chunk.length;
      },
      onDone: () {
        final contentLength = event.contentLength ?? 0;
        final progress = (downloadedBytes / contentLength) * 100;
        downloadProgress(contentLength, downloadedBytes, progress);

        int start = 0;
        final bytes = Uint8List(contentLength);

        for (var chunk in chunkList) {
          bytes.setRange(start, start + chunk.length, chunk);
          start += chunk.length;
        }
        completer.complete(bytes);
      },
      onError: (error) => completer.completeError(error),
    );
  });
  return completer.future;
}

_requestPermission() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
  ].request();
  final info = statuses[Permission.storage].toString();
  debugPrint(info);
}
