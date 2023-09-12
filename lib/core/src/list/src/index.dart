import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';

class WList<T> extends StatefulWidget {
  final Function(Map<String, dynamic>, int, int, Map<String, dynamic>)? api;
  final Function(T item)? apiId;
  final Widget? top;
  final Widget? bottom;
  final ScrollPhysics? physics;
  final Function(T content, int index) item;
  final Function(dynamic json)? format;
  final Function(T content)? onTap;
  final Function(T content, BuildContext context)? onTapMultiple;
  final CrossAxisAlignment crossAxisAlignment;
  final List? items;
  final AppStatus status;
  final InputDisplayType inputDisplayType;
  final Widget? separator;
  final int flex;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final Function(dynamic cubit)? init;

  const WList({
    super.key,
    this.top,
    this.api,
    required this.item,
    this.format,
    this.onTap,
    this.items,
    this.bottom,
    this.status = AppStatus.init,
    this.inputDisplayType = InputDisplayType.outside,
    this.separator,
    this.onTapMultiple,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.physics,
    this.flex = 1,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.init,
    this.apiId,
  });

  @override
  State<WList<T>> createState() => _WListState<T>();
}

class _WListState<T> extends State<WList<T>> {
  final StreamController<bool> loadMoreController = StreamController<bool>.broadcast();
  bool isLoadMore = false;
  late ScrollController controller;
  final int size = 20;
  Timer t = Timer(const Duration(seconds: 1), () {});
  late final String currentUrl;
  int? index;
  T? item;

  @override
  void initState() {
    currentUrl = GoRouter.of(rootNavigatorKey.currentState!.context).location;
    final BlocC<T> blocC = context.read<BlocC<T>>();
    if (widget.items == null) {
      if (widget.init != null) {
        widget.init!(blocC);
      }
      blocC.setSize(
        size: size,
        api: widget.api ?? (_, __, ___, ____) {},
        format: widget.format ?? MAttachment.fromJson,
      );
    } else {
      List? content = widget.items;
      blocC.setData(
        data: MData.fromJson({
          'page': 1,
          'totalPages': content!.length,
          'size': content.length,
          'numberOfElements': content.length,
          'totalElements': content.length,
          'content': content
        }, widget.format),
        status: widget.status,
      );
    }
    if (widget.items == null) {
      controller = ScrollController()..addListener(scrollListener);
    }
    super.initState();
  }

  @override
  void dispose() {
    loadMoreController.close();
    if (widget.items == null) {
      controller.removeListener(scrollListener);
      t.cancel();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WList<T> oldWidget) {
    setCurrentUrl();
    super.didUpdateWidget(oldWidget);
  }

  Future<void> setCurrentUrl() async {
    String location = GoRouter.of(context).location;
    if (location.contains('?')) {
      location = location.substring(0, location.indexOf('?'));
    }
    if (currentUrl == location && widget.items == null && item != null && index != null && widget.format != null) {
      await context
          .read<BlocC<T>>()
          .refreshPage(index: index!, apiId: widget.apiId!(item as T), format: widget.format!);
      index = null;
      item = null;
    }
  }

  void scrollListener() async {
    const int space = 100;
    if (widget.items != null) return;
    final BlocC cubit = context.read<BlocC<T>>();
    final bool increasePage =
        cubit.state.data.content.length >= size && cubit.state.data.content.length < cubit.state.data.totalElements!;
    if (controller.position.pixels >= controller.position.maxScrollExtent - space &&
        context.mounted &&
        increasePage &&
        !isLoadMore) {
      isLoadMore = true;
      loadMoreController.sink.add(true);
      await cubit.increasePage(api: widget.api ?? (_, __, ___, ____) {}, format: widget.format ?? MAttachment.fromJson);
      loadMoreController.sink.add(false);
      isLoadMore = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlocC<T>, BlocS<T>>(
        buildWhen: (bf, at) => isLoadMore == false,
        builder: (context, state) {
          final int length =
              state.data.content.isNotEmpty && state.status != AppStatus.fails ? state.data.content.length : 1;
          if (state.status == AppStatus.inProcess) return WLoading();

          return RefreshIndicator(
            notificationPredicate: widget.items == null ? (_) => true : (_) => false,
            onRefresh: () async {
              if (widget.items == null) {
                await context.read<BlocC<T>>().setPage(
                      page: 1,
                      api: widget.api ?? (_, __, ___, ____) {},
                      format: widget.format ?? MAttachment.fromJson,
                    );
              }
            },
            child: Container(
              padding: widget.padding ?? EdgeInsets.zero,
              margin: widget.margin ?? EdgeInsets.zero,
              color: widget.backgroundColor ?? Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: widget.crossAxisAlignment,
                children: [
                  if (widget.inputDisplayType == InputDisplayType.outside) widget.top ?? Container(),
                  state.data.content.isNotEmpty
                      ? Flexible(
                          flex: widget.flex,
                          child: ListView.separated(
                            physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            controller: widget.items == null ? controller : null,
                            itemBuilder: (_, index) {
                              if (state.status == AppStatus.fails) {
                                return Container(
                                  height: 150,
                                  alignment: Alignment.center,
                                  child:
                                      Text('Oops!, có lỗi xảy ra...', style: TextStyle(color: CColor.black.shade300)),
                                );
                              }
                              final item = state.data.content[index];
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: widget.crossAxisAlignment,
                                children: [
                                  if (index == 0 && widget.inputDisplayType == InputDisplayType.inside)
                                    widget.top ?? Container(),
                                  state.data.content.isNotEmpty
                                      ? InkWell(
                                          splashColor: CColor.primary.shade100,
                                          onTap: (widget.onTap != null || widget.onTapMultiple != null)
                                              ? () async {
                                                  if (widget.onTap != null) {
                                                    this.index = index;
                                                    if (widget.apiId != null) {
                                                      this.item = item;
                                                    }
                                                    widget.onTap!(item);
                                                  } else if (widget.onTapMultiple != null) {
                                                    widget.onTapMultiple!(item, context);
                                                  }
                                                }
                                              : null,
                                          child: widget.item(item, index),
                                        )
                                      : const Padding(
                                          padding: EdgeInsets.only(top: CSpace.large),
                                          child: Text('Danh sách trống'),
                                        ),
                                  if (widget.items == null && index == length - 1)
                                    StreamBuilder<bool>(
                                      stream: loadMoreController.stream,
                                      builder: (_, snapshot) {
                                        if (snapshot.hasData && snapshot.data == true) {
                                          return WLoading();
                                        }
                                        return Container();
                                      },
                                    ),
                                  if (index == length - 1 && widget.inputDisplayType == InputDisplayType.inside)
                                    widget.bottom ?? Container(),
                                ],
                              );
                            },
                            itemCount: length,
                            separatorBuilder: (_, int index) {
                              if (widget.items?[index].runtimeType == MFormItem &&
                                  (widget.items?[index]?.dataType == DataType.separation)) {
                                return Container();
                              }
                              return widget.separator ?? Container();
                            },
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: CSpace.large),
                          child: BlocSelector<BlocC, BlocS, int>(
                            selector: (state) => state.data.content.length,
                            builder: (context, state) {
                              return const Text('Danh sách trống');
                            },
                          )),
                  if (widget.inputDisplayType == InputDisplayType.outside) widget.bottom ?? Container(),
                ],
              ),
            ),
          );
        });
  }
}

//Tùy chỉnh cách hiển thị các input lẻ
enum InputDisplayType { inside, outside }