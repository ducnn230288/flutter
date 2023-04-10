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
    List<MFormItem> listFormItem = [
      MFormItem(name: 'fullTextSearch', label: 'Tìm kiếm người dùng'),
    ];

    return Scaffold(
        appBar: appBar(title: 'Người dùng'),
        body: WList(
            top: Column(
              children: [
                const SizedBox(
                  height: CSpace.large / 2,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: CSpace.large),
                  child: Row(
                    children: [
                      Flexible(child: WForm(list: listFormItem)),
                      const SizedBox(
                        width: CSpace.large,
                      ),
                      SizedBox(
                        width: CHeight.medium,
                        child: ElevatedButton(
                            onPressed: () => context.read<BlocC>().submit(
                                api: (filter, page, size, sort) => RepositoryProvider.of<Api>(context)
                                    .user
                                    .get(filter: filter, page: page, size: size),
                                getData: true,
                                format: MUser.fromJson),
                            child: CIcon.search),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            item: (content, int index){
              MUser item =content;
              return Container(
                  padding: const EdgeInsets.symmetric(horizontal: CSpace.large),
                  child: itemList(
                    leading: CIcon.placeholderImage,
                    title: Text(item.name ?? '', style: TextStyle(color: CColor.primary, fontSize: CFontSize.paragraph1)),
                    content: Text(
                      item.email ?? '',
                      style: TextStyle(color: CColor.black.shade200, fontSize: CFontSize.paragraph2),
                    ),
                    onTap: () {},
                  ));
            },
            format: MUser.fromJson,
            api: (filter, page, size, sort) =>
                RepositoryProvider.of<Api>(context).user.get(filter: filter, page: page, size: size)));
  }
}
