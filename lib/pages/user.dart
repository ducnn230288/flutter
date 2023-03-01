import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/constants/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';
import '/widgets/index.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
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
      context.read<AppFormCubit>().increasePage(
          auth: context.read<AppAuthCubit>(),
          api: (filter, logout, page, size, sort) =>
              RepositoryProvider.of<Api>(context).getUser(logout: logout, filter: filter, page: page, size: size),
          format: ModelUser.fromJson);
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
    AppAuthCubit auth = context.read<AppAuthCubit>();
    context.read<AppFormCubit>().setSize(
        size: 20,
        auth: context.read<AppAuthCubit>(),
        api: (filter, logout, page, size, sort) =>
            RepositoryProvider.of<Api>(context).getUser(logout: logout, filter: filter, page: page, size: size),
        format: ModelUser.fromJson);
    List<ModelFormItem> listFormItem = [
      ModelFormItem(name: 'fullTextSearch', label: 'Tìm kiếm người dùng', icon: 'assets/form/search.svg'),
    ];

    return Scaffold(
        appBar: appBar(title: 'Người dùng', context: context),
        body: BlocBuilder<AppFormCubit, AppFormState>(
            builder: (context, state) => ListView.builder(
                  controller: controller,
                  itemBuilder: (context, index) {
                    ModelUser item = state.data.content[index];
                    return Column(
                      children: [
                        (index == 0)
                            ? Column(
                                children: [
                                  const SizedBox(
                                    height: Space.large / 2,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: Space.large),
                                    child: Column(
                                      children: [
                                        WidgetForm(list: listFormItem),
                                        BlocBuilder<AppFormCubit, AppFormState>(
                                          builder: (context, state) => ElevatedButton(
                                              onPressed: () => context.read<AppFormCubit>().submit(
                                                  context: context,
                                                  auth: auth,
                                                  api: (filter, logout, page, size, sort) =>
                                                      RepositoryProvider.of<Api>(context)
                                                          .getUser(logout: logout, filter: filter, page: page),
                                                  getData: true,
                                                  format: ModelUser.fromJson),
                                              child: const Text('Tìm kiếm')),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: Space.large),
                            child: listTile(
                              leading: AppIcons.placeholderImage,
                              title: Text(item.name,
                                  style: TextStyle(color: ColorName.primary, fontSize: FontSizes.paragraph1)),
                              content: Text(
                                item.email,
                                style: TextStyle(color: ColorName.black.shade200, fontSize: FontSizes.paragraph2),
                              ),
                              onTap: () {},
                            )),
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
                )));
  }
}
