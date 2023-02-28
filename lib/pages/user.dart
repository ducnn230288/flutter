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
      ModelFormItem(name: 'username', label: 'Tìm kiếm người dùng', icon: 'assets/form/search.svg'),
    ];

    return Scaffold(
      appBar: appBar(title: 'Người dùng', context: context),
      body: ListView(
        children: [
          const SizedBox(
            height: Space.large / 2,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Space.large),
            child: BlocProvider(
                create: (context) => AppFormCubit(),
                child: Column(
                  children: [
                    WidgetForm(list: listFormItem),
                    BlocBuilder<AppAuthCubit, AppAuthState>(
                      builder: (context, state) => ElevatedButton(
                          onPressed: () => context.read<AppFormCubit>().submit(
                                context: context,
                                auth: auth,
                                api: (body, logout) => RepositoryProvider.of<Api>(context).getUser(logout: logout),
                                submit: (data) => context
                                    .read<AppListCubit>()
                                    .setList<ModelUser>(list: data.content, format: ModelUser.fromJson),
                                getData: true,
                              ),
                          child: const Text('Tìm kiếm')),
                    )
                  ],
                )),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Space.large),
            child: BlocBuilder<AppListCubit, AppListState>(
              builder: (context, state) {
                return Column(children: <Widget>[
                  ...List.generate(state.list.length, (index) {
                    ModelUser item = state.list[index];
                    return listTile(
                      leading: AppIcons.placeholderImage,
                      title:
                          Text(item.name, style: TextStyle(color: ColorName.primary, fontSize: FontSizes.paragraph1)),
                      content: Text(
                        item.email,
                        style: TextStyle(color: ColorName.black.shade200, fontSize: FontSizes.paragraph2),
                      ),
                      onTap: () {},
                    );
                  })
                ]);
                // return listTile(
                //   leading: AppIcons.placeholderImage,
                //   title: Text('How to Take a Proper Batting Stance Take a Proper Batting Stance',
                //       style: TextStyle(color: ColorName.primary, fontSize: FontSizes.paragraph1)),
                //   content: Text(
                //     'How to Take a Proper Batting Stance Take a Proper Batting Stance',
                //     style: TextStyle(color: ColorName.black.shade200, fontSize: FontSizes.paragraph2),
                //   ),
                //   onTap: () {},
                // );
              },
            ),
          )
        ],
      ),
    );
  }
}
