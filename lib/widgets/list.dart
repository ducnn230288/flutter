import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/constants/index.dart';
import '/cubit/index.dart';

class WidgetList extends StatefulWidget {
  final Function api;
  final Widget top;
  final Function item;
  final Function format;
  const WidgetList({super.key, required this.api, required this.top, required this.item, required this.format});

  @override
  State<WidgetList> createState() => _WidgetListState();
}

class _WidgetListState extends State<WidgetList> {
  late ScrollController controller;
  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() async {
    if (controller.position.pixels == controller.position.maxScrollExtent && context.mounted) {
      context
          .read<AppFormCubit>()
          .increasePage(auth: context.read<AppAuthCubit>(), api: widget.api, format: widget.format);
    }
    if (controller.position.pixels < controller.position.maxScrollExtent + 100) {
      await Future.delayed(const Duration(microseconds: 200000));
      if (context.mounted) {
        context.read<AppFormCubit>().setStatus(status: AppStatus.inProcess);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    context
        .read<AppFormCubit>()
        .setSize(size: 20, auth: context.read<AppAuthCubit>(), api: widget.api, format: widget.format);

    return BlocBuilder<AppFormCubit, AppFormState>(
        builder: (context, state) => ListView.builder(
              controller: controller,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    (index == 0) ? widget.top : const SizedBox(),
                    widget.item(state.data.content[index]),
                    (index == state.data.content.length - 1 && state.status == AppStatus.inProcess)
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
                );
              },
              itemCount: state.data.content.length,
            ));
  }
}
