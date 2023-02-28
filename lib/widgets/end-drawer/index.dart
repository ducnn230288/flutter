import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/constants/index.dart';
import 'list_tile.dart';

endDrawer({context}) {
  double h = MediaQuery.of(context).viewPadding.top - 15;
  return Drawer(
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.large),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(
                height: 70,
              ),
              itemDrawer(
                  svg: 'assets/form/full-name.svg',
                  name: 'Users',
                  onTap: () => GoRouter.of(context).pushNamed(
                        RoutesName.user,
                      )),
            ],
          ),
        ),
        Positioned(
          top: Space.large + h,
          right: Space.large,
          width: 40,
          height: 40,
          child: Builder(
              builder: (context) => ElevatedButton(
                    onPressed: () {
                      Scaffold.of(context).closeEndDrawer();
                    },
                    child: AppIcons.close,
                  )),
        ),
      ],
    ),
  );
}
