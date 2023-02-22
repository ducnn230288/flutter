import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: AppThemes.gap),
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: AppThemes.gap / 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Text'),
                SizedBox(
                    width: 40,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: AppThemes.buttonWhite,
                      child: SvgPicture.asset(
                        'assets/svgs/menu-right.svg',
                        semanticsLabel: 'Menu',
                        width: 24,
                        color: AppThemes.blackColor,
                      ),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
