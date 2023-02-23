import 'package:flutter/material.dart';

import '/constants.dart';
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
      ),
    );
  }
}
