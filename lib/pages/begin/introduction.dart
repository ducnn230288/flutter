import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '/utils.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  final _introKey = GlobalKey<IntroductionScreenState>();
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: _introKey,
      pages: [
        PageViewModel(
          titleWidget: Text(
            "Không có ai muốn khổ đau cho chính mình.",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 32.0,
              color: AppThemes.blackColor,
            ),
          ),
          bodyWidget: Text(
            "Không có ai muốn khổ đau cho chính mình, muốn tìm kiếm về nó và muốn có nó, bởi vì nó là sự đau khổ. Không có ai muốn khổ đau cho chính mình, muốn tìm kiếm về nó và muốn có nó, bởi vì nó là sự đau khổ. Không có ai muốn khổ đau cho chính mình, muốn tìm kiếm về nó và muốn có nó, bởi vì nó là sự đau khổ. ",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14.0, color: AppThemes.blackColor),
          ),
          image: SvgPicture.asset('assets/svgs/logo.svg', semanticsLabel: 'Logo'),
          decoration: const PageDecoration(imagePadding: EdgeInsets.only(top: 24.0)),
        ),
        PageViewModel(
          titleWidget: Text(
            "Không có ai muốn khổ đau cho chính mình.",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 32.0,
              color: AppThemes.blackColor,
            ),
          ),
          bodyWidget: Text(
            "Không có ai muốn khổ đau cho chính mình, muốn tìm kiếm về nó và muốn có nó, bởi vì nó là sự đau khổ. Không có ai muốn khổ đau cho chính mình, muốn tìm kiếm về nó và muốn có nó, bởi vì nó là sự đau khổ. Không có ai muốn khổ đau cho chính mình, muốn tìm kiếm về nó và muốn có nó, bởi vì nó là sự đau khổ. ",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14.0, color: AppThemes.blackColor),
          ),
          image: SvgPicture.asset('assets/svgs/logo.svg', semanticsLabel: 'Logo'),
          decoration: const PageDecoration(imagePadding: EdgeInsets.only(top: 24.0)),
        ),
        PageViewModel(
          titleWidget: Text(
            "Không có ai muốn khổ đau cho chính mình.",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 32.0,
              color: AppThemes.blackColor,
            ),
          ),
          bodyWidget: Text(
            "Không có ai muốn khổ đau cho chính mình, muốn tìm kiếm về nó và muốn có nó, bởi vì nó là sự đau khổ. Không có ai muốn khổ đau cho chính mình, muốn tìm kiếm về nó và muốn có nó, bởi vì nó là sự đau khổ. Không có ai muốn khổ đau cho chính mình, muốn tìm kiếm về nó và muốn có nó, bởi vì nó là sự đau khổ. ",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14.0, color: AppThemes.blackColor),
          ),
          image: SvgPicture.asset('assets/svgs/logo.svg', semanticsLabel: 'Logo'),
          decoration: const PageDecoration(imagePadding: EdgeInsets.only(top: 24.0)),
        ),
        PageViewModel(
          titleWidget: Text(
            "Không có ai muốn khổ đau cho chính mình.",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 32.0,
              color: AppThemes.blackColor,
            ),
          ),
          bodyWidget: Text(
            "Không có ai muốn khổ đau cho chính mình, muốn tìm kiếm về nó và muốn có nó, bởi vì nó là sự đau khổ. Không có ai muốn khổ đau cho chính mình, muốn tìm kiếm về nó và muốn có nó, bởi vì nó là sự đau khổ. Không có ai muốn khổ đau cho chính mình, muốn tìm kiếm về nó và muốn có nó, bởi vì nó là sự đau khổ. ",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14.0, color: AppThemes.blackColor),
          ),
          image: SvgPicture.asset('assets/svgs/logo.svg', semanticsLabel: 'Logo'),
          decoration: const PageDecoration(imagePadding: EdgeInsets.only(top: 24.0)),
        ),
      ],
      isTopSafeArea: true,
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Theme.of(context).colorScheme.secondary,
        color: Colors.grey.shade300,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
      showSkipButton: true,
      skip: const Text("Bỏ qua"),
      showNextButton: true,
      next: const Text("Tiếp tục"),
      nextStyle: AppThemes.buttonStyle,
      doneStyle: AppThemes.buttonStyle,
      done: const Text("Bắt đầu"),
      onDone: () {
        Navigator.pushNamed(context, RoutesName.loginPage);
      },
    );
  }
}
