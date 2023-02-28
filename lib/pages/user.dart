import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uberentaltest/cubit/form.dart';

import '/constants/index.dart';
import '/models/form.dart';
import '/widgets/index.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ModelFormItem> listFormItem = [
      ModelFormItem(name: 'username', label: 'Tìm kiếm người dùng', icon: 'assets/form/search.svg'),
    ];

    return Scaffold(
      appBar: appBar(title: 'Người dùng', context: context),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: Space.large),
        child: Column(
          children: [
            const SizedBox(
              height: Space.large / 2,
            ),
            BlocProvider(create: (context) => AppFormCubit(), child: WidgetForm(list: listFormItem)),
            const SizedBox(
              height: Space.large / 2,
            ),
          ],
        ),
      ),
    );
  }
}
