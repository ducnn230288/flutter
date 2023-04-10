import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uberental/constants/dimens.dart';

import '/cubit/index.dart';
import '/models/index.dart';
import '/widgets/index.dart';

class WList extends StatefulWidget {
  final Function(Map<String, dynamic>, int, int, Map<String, dynamic>)? api;
  final Widget? top;
  final Widget? bottom;
  final Function(dynamic content, int index) item;
  final Function? format;
  final Function(dynamic content)? onTap;
  final Function(dynamic content, BuildContext context)? onTapMultiple;
  final bool loadMore;
  final List? items;
  final bool isPage;
  final double heightItem;
  final num extendItem;
  final AppStatus status;
  final InputDisplayType inputDisplayType;
  final Widget? separator;

  const WList({
    super.key,
    this.top,
    this.api,
    required this.item,
    this.format,
    this.onTap,
    this.items,
    this.loadMore = true,
    this.isPage = true,
    this.heightItem = 45.0,
    this.extendItem = 0,
    this.bottom,
    this.status = AppStatus.init,
    this.inputDisplayType = InputDisplayType.outside,
    this.separator,
    this.onTapMultiple,
  });

  @override
  State<WList> createState() => _WListState();
}

class _WListState extends State<WList> {
  late ScrollController controller;
  final int size = 20;
  Timer t = Timer(const Duration(seconds: 1), () {});
  String? currentUrl;

  @override
  void initState() {
    final BlocC blocC = context.read<BlocC>();
    super.initState();
    if (widget.items == null) {
      blocC.setSize(
          size: size, api: widget.api ?? (filter, page, size, sort) {}, format: widget.format ?? MAttachment.fromJson);
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
    if (widget.loadMore) {
      controller = ScrollController()..addListener(_scrollListener);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.loadMore) {
      controller.removeListener(_scrollListener);
      t.cancel();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (currentUrl == null) {
      currentUrl = GoRouter.of(context).location;
    } else if (currentUrl == GoRouter.of(context).location) {
      context.read<BlocC>().setSize(
          size: size, api: widget.api ?? (filter, page, size, sort) {}, format: widget.format ?? MAttachment.fromJson);
    }
  }

  void _scrollListener() async {
    if (widget.items != null) return;
    final BlocC blocC = context.read<BlocC>();
    bool increasePage = blocC.state.data.content != null &&
        blocC.state.data.content!.length >= size &&
        blocC.state.data.content!.length < blocC.state.data.totalElements!;
    if (controller.position.pixels == controller.position.maxScrollExtent && context.mounted && increasePage) {
      context.read<BlocC>().increasePage(
          api: widget.api ?? (filter, page, size, sort) {}, format: widget.format ?? MAttachment.fromJson);
    }
    if (controller.position.extentAfter < 10 && increasePage) {
      t.cancel();
      t = Timer(const Duration(milliseconds: 50), () {
        if (context.mounted) {
          context.read<BlocC>().setStatus(status: AppStatus.inProcess);
        }
      });
    }
    if (controller.position.extentAfter < 10 &&
        !increasePage &&
        context.read<BlocC>().state.status == AppStatus.inProcess) {
      context.read<BlocC>().setStatus(status: AppStatus.init);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlocC, BlocS>(builder: (context, state) {
      final int length = state.data.content!.isNotEmpty ? state.data.content!.length : 1;
      return RefreshIndicator(
        notificationPredicate: widget.items == null ? (_) => true : (_) => false,
        onRefresh: () async {
          if (widget.items == null) {
            context.read<BlocC>().setPage(
                page: 1,
                api: widget.api ?? (filter, page, size, sort) {},
                format: widget.format ?? MAttachment.fromJson);
          }
        },
        child: SizedBox(
          height: !widget.isPage
              ? (widget.heightItem *
                  ((widget.items != null ? widget.items!.length : state.data.content!.length) + widget.extendItem))
              : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.inputDisplayType == InputDisplayType.outside) widget.top ?? Container(),
              Expanded(
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  controller: widget.loadMore ? controller : null,
                  itemBuilder: (_, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (index == 0 && widget.inputDisplayType == InputDisplayType.inside) widget.top ?? Container(),
                        if (state.data.content!.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              if (widget.onTap != null) widget.onTap!(state.data.content![index]);
                              if (widget.onTapMultiple != null)
                                widget.onTapMultiple!(state.data.content![index], context);
                            },
                            child: widget.item(state.data.content![index], index),
                          ),
                        if (index == length - 1 && widget.inputDisplayType == InputDisplayType.inside)
                          widget.bottom ?? Container(),
                        if (widget.loadMore && index == length - 1 && state.status == AppStatus.inProcess)
                          progressIndicator()
                      ],
                    );
                  },
                  itemCount: length,
                  separatorBuilder: (_, int index) {
                    if (widget.items?[index].runtimeType == MFormItem &&
                        (widget.items?[index]?.dataType == DataType.separation ||
                            widget.items?[index + 1]?.dataType == DataType.separation)) {
                      return Container();
                    }
                    return Container(
                        margin: const EdgeInsets.symmetric(horizontal: CSpace.large),
                        child: widget.separator ?? Container());
                  },
                ),
              ),
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
