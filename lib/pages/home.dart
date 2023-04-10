import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/constants/index.dart';
import '/widgets/index.dart';
import '../cubit/index.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: Colors.white,
      drawer: drawer(),
      body: BlocBuilder<AuthC, AuthS>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: CSpace.large),
            child: ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(height: CSpace.large / 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: 40,
                        height: 40,
                        child: Builder(
                            builder: (context) => ElevatedButton(
                                  onPressed: () => Scaffold.of(context).openDrawer(),
                                  style: CStyle.buttonWhite,
                                  child: CIcon.menuRight,
                                ))),
                    Text('example.hello'.tr()),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
