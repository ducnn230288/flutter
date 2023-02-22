import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/utils.dart';
import '/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: Colors.white,
      endDrawer: endDrawer(context: context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: AppThemes.gap),
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: AppThemes.gap / 4,
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
                              style: AppThemes.buttonWhite,
                              child: SvgPicture.asset(
                                'assets/svgs/menu-right.svg',
                                semanticsLabel: 'Menu',
                                width: 24,
                                color: AppThemes.blackColor,
                              ),
                            ))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
