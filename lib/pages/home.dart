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
      endDrawer: endDrawer(context: context),
      body: BlocBuilder<AppAuthCubit, AppAuthState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: Space.large),
            child: ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(
                  height: Space.large / 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Text'),
                    SizedBox(
                        width: 40,
                        height: 40,
                        child: Builder(
                            builder: (context) => ElevatedButton(
                                  onPressed: () {
                                    Scaffold.of(context).openEndDrawer();
                                  },
                                  style: Style.buttonWhite,
                                  child: AppIcons.menuRight,
                                ))),
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
