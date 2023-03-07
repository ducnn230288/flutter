import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/constants/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';

class WidgetList extends StatefulWidget {
  final Function api;
  final Widget top;
  final Function item;
  final Function format;
  final Function? onTap;
  final bool loadMore;
  final List? items;
  final bool isPage;
  final double heightItem;
  final num extendItem;
  const WidgetList({
    super.key,
    required this.api,
    required this.top,
    required this.item,
    required this.format,
    this.onTap,
    this.items,
    this.loadMore = true,
    this.isPage = true,
    this.heightItem = 45.0,
    this.extendItem = 0,
  });

  @override
  State<WidgetList> createState() => _WidgetListState();
}

class _WidgetListState extends State<WidgetList> {
  late ScrollController controller;
  Timer t = Timer(const Duration(seconds: 1), () {});

  @override
  void initState() {
    super.initState();
    if (widget.items == null) {
      context
          .read<AppFormCubit>()
          .setSize(size: 20, auth: context.read<AppAuthCubit>(), api: widget.api, format: widget.format);
    } else {
      context.read<AppFormCubit>().setData(
              data: ModelData.fromJson({
            'page': 1,
            'totalPages': widget.items!.length,
            'size': widget.items!.length,
            'numberOfElements': widget.items!.length,
            'totalElements': widget.items!.length,
            'content': widget.items
          }, widget.format));
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

  void _scrollListener() async {
    if (controller.position.pixels == controller.position.maxScrollExtent && context.mounted) {
      context
          .read<AppFormCubit>()
          .increasePage(auth: context.read<AppAuthCubit>(), api: widget.api, format: widget.format);
    }
    if (controller.position.pixels < controller.position.maxScrollExtent + 100) {
      t.cancel();
      t = Timer(const Duration(microseconds: 200000), () {
        if (context.mounted) {
          context.read<AppFormCubit>().setStatus(status: AppStatus.inProcess);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppFormCubit, AppFormState>(
        builder: (context, state) => SizedBox(
              height: !widget.isPage
                  ? (widget.heightItem *
                      ((widget.items != null ? widget.items!.length : state.data.content.length) + widget.extendItem))
                  : null,
              child: ListView.builder(
                controller: widget.loadMore ? controller : null,
                itemBuilder: (context, index) => Column(
                  children: [
                    (index == 0) ? widget.top : const SizedBox(),
                    state.data.content.isNotEmpty
                        ? widget.item(state.data.content[index], () => widget.onTap!(state.data.content[index]))
                        : const SizedBox(),
                    (widget.loadMore && index == state.data.content.length - 1 && state.status == AppStatus.inProcess)
                        ? Column(
                            children: const [
                              SizedBox(
                                height: Space.medium,
                              ),
                              CircularProgressIndicator(),
                              SizedBox(
                                height: Space.medium,
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
                itemCount: state.data.content.isNotEmpty ? state.data.content.length : 1,
              ),
            ));
  }
}
