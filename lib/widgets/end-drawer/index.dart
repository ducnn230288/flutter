import 'package:flutter/material.dart';

import '/constants/index.dart';
import 'list-tile.dart';

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
              itemDrawer(svg: 'assets/svgs/menu-right.svg', name: 'Order', onTap: () {}),
              itemDrawer(svg: 'assets/svgs/menu-right.svg', name: 'Đặt cọc'),
              itemDrawer(svg: 'assets/svgs/menu-right.svg', name: 'Hoa hồng'),
              itemDrawer(svg: 'assets/svgs/menu-right.svg', name: 'Kết nối'),
              itemDrawer(svg: 'assets/svgs/menu-right.svg', name: 'Phòng khám'),
              itemDrawer(svg: 'assets/svgs/menu-right.svg', name: 'Phản hồi'),
              itemDrawer(svg: 'assets/svgs/menu-right.svg', name: 'Farmmer'),
              itemDrawer(svg: 'assets/svgs/menu-right.svg', name: 'Cá nhân', isBorder: false),
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