import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/constants/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/utils/index.dart';
import '/widgets/index.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppAuthCubit auth = context.read<AppAuthCubit>();
    List<ModelFormItem> listFormItem = [
      ModelFormItem(name: 'fullTextSearch', label: 'Tìm kiếm người dùng'),
    ];

    return Scaffold(
        appBar: appBar(title: 'Người dùng', context: context),
        body: WidgetList(
            top: Column(
              children: [
                const SizedBox(
                  height: Space.large / 2,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Space.large),
                  child: Row(
                    children: [
                      Flexible(child: WidgetForm(list: listFormItem)),
                      const SizedBox(
                        width: Space.large,
                      ),
                      SizedBox(
                        width: Height.medium,
                        child: ElevatedButton(
                            onPressed: () => context.read<AppFormCubit>().submit(
                                context: context,
                                auth: auth,
                                api: (filter, logout, page, size, sort) => RepositoryProvider.of<Api>(context)
                                    .getUser(logout: logout, filter: filter, page: page, size: size),
                                getData: true,
                                format: ModelUser.fromJson),
                            child: AppIcons.search),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            item: (ModelUser item) => Container(
                padding: const EdgeInsets.symmetric(horizontal: Space.large),
                child: itemList(
                  leading: AppIcons.placeholderImage,
                  title: Text(item.name, style: TextStyle(color: ColorName.primary, fontSize: FontSizes.paragraph1)),
                  content: Text(
                    item.email,
                    style: TextStyle(color: ColorName.black.shade200, fontSize: FontSizes.paragraph2),
                  ),
                  onTap: () {},
                )),
            format: ModelUser.fromJson,
            api: (filter, logout, page, size, sort) =>
                RepositoryProvider.of<Api>(context).getUser(logout: logout, filter: filter, page: page, size: size)));
  }
}
