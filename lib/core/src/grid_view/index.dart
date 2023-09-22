import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';

part '_dynamic_height_grid_view.dart';

class GridRefresh<T> extends StatefulWidget {
  final Function(Map<String, dynamic>, int, int, Map<String, dynamic>) api;
  final Function(T item)? apiId;
  final double? height;
  final Function? onLoadMore;
  final Function(T) format;
  final Widget Function(T item, int index) item;
  final Function(T)? onTap;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsets? padding;

  const GridRefresh({
    Key? key,
    this.height,
    this.onLoadMore,
    required this.item,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    required this.format,
    required this.api,
    this.padding,
    this.onTap,
    this.apiId,
  }) : super(key: key);

  @override
  _GridRefreshState<T> createState() => _GridRefreshState<T>();
}

class _GridRefreshState<T> extends State<GridRefresh<T>> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          Future block = context.read<BlocC<T>>().stream.first;
          await context.read<BlocC<T>>().setPage(page: 1, api: widget.api, format: widget.format);
          await block;
        },
        child: BlocBuilder<BlocC<T>, BlocS<T>>(
          builder: (context, state) {
            if (state.data.content.isEmpty) {
              if (state.status == AppStatus.inProcess) {
                return WLoading();
              }
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Container(
                    height: 150,
                    alignment: Alignment.center,
                    child: Text('Danh sách trống', style: TextStyle(color: CColor.black.shade300)),
                  ),
                ],
              );
            }
            return DynamicHeightGridView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              itemCount: state.data.content.length + 1,
              crossAxisCount: widget.crossAxisCount,
              crossAxisSpacing: widget.crossAxisSpacing,
              mainAxisSpacing: widget.mainAxisSpacing,
              builder: (_, index) {
                if (index < state.data.content.length) {
                  return InkWell(
                    splashColor: CColor.primary.shade100,
                    onTap: widget.onTap != null
                        ? () {
                            if (widget.apiId != null) {
                              item = state.data.content[index];
                              this.index = index;
                            }
                            widget.onTap!(state.data.content[index]);
                          }
                        : null,
                    child: widget.item(state.data.content[index], index),
                  );
                } else {
                  return StreamBuilder<bool>(
                    stream: _streamController.stream,
                    builder: (_, snapshot) => (snapshot.data ?? false) ? WLoading() : Container(),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollController = ScrollController();
  final StreamController<bool> _streamController = StreamController<bool>.broadcast();
  late final String currentUrl;
  late final BlocC<T> cubit;
  bool isLoadMore = false;
  int? index;
  T? item;

  @override
  void initState() {
    cubit = context.read<BlocC<T>>();
    cubit.setSize(size: 20, api: widget.api, format: widget.format);
    currentUrl = GoRouter.of(rootNavigatorKey.currentState!.context).location;
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _streamController.close();
    super.dispose();
  }

  void _scrollListener() async {
    if (_scrollController.position.extentAfter < 50 &&
        cubit.state.data.content.length >= cubit.state.size &&
        !isLoadMore) {
      isLoadMore = true;
      _streamController.add(true);
      await context.read<BlocC<T>>().increasePage(api: widget.api, format: widget.format);
      _streamController.add(false);
      isLoadMore = false;
    }
  }

  @override
  void didUpdateWidget(covariant GridRefresh<T> oldWidget) {
    refresh();
    super.didUpdateWidget(oldWidget);
  }

  Future<void> refresh() async {
    String location = GoRouter.of(context).location;
    if (location.contains('?')) {
      location = location.substring(0, location.indexOf('?'));
    }
    if (currentUrl == location && index != null) {
      await context.read<BlocC<T>>().refreshPage(index: index!, apiId: widget.apiId!(item!), format: widget.format);
      index = null;
      item = null;
    }
  }
}
