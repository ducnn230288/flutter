import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../constants/index.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          titleWidget: Text(
            "Không có ai muốn khổ đau cho chính mình.",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: FontSizes.headline1,
              color: ColorName.black,
            ),
          ),
          bodyWidget: Text(
            "Không có ai muốn khổ đau cho chính mình, muốn tìm kiếm về nó và muốn có nó, bởi vì nó là sự đau khổ. Không có ai muốn khổ đau cho chính mình, muốn tìm kiếm về nó và muốn có nó, bởi vì nó là sự đau khổ. Không có ai muốn khổ đau cho chính mình, muốn tìm kiếm về nó và muốn có nó, bởi vì nó là sự đau khổ. ",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: FontSizes.paragraph1, color: ColorName.black.shade500),
          ),
          image: AppIcons.logo,
          decoration: const PageDecoration(imagePadding: EdgeInsets.only(top: Space.superLarge)),
        ),
        PageViewModel(
          titleWidget: Text(
            "Không có ai muốn khổ đau cho chính mình.",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: FontSizes.headline1,
              color: ColorName.black,
            ),
          ),
          bodyWidget: Text(
            "Không có ai muốn khổ đau cho chính mình, muốn tìm kiếm về nó và muốn có nó, bởi vì nó là sự đau khổ. Không có ai muốn khổ đau cho chính mình, muốn tìm kiếm về nó và muốn có nó, bởi vì nó là sự đau khổ. Không có ai muốn khổ đau cho chính mình, muốn tìm kiếm về nó và muốn có nó, bởi vì nó là sự đau khổ. ",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: FontSizes.paragraph1, color: ColorName.black.shade500),
          ),
          image: AppIcons.logo,
          decoration: const PageDecoration(imagePadding: EdgeInsets.only(top: Space.superLarge)),
        ),
        PageViewModel(
          titleWidget: Text(
            "Không có ai muốn khổ đau cho chính mình.",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: FontSizes.headline1,
              color: ColorName.black,
            ),
          ),
          bodyWidget: Text(
            "Không có ai muốn khổ đau cho chính mình, muốn tìm kiếm về nó và muốn có nó, bởi vì nó là sự đau khổ. Không có ai muốn khổ đau cho chính mình, muốn tìm kiếm về nó và muốn có nó, bởi vì nó là sự đau khổ. Không có ai muốn khổ đau cho chính mình, muốn tìm kiếm về nó và muốn có nó, bởi vì nó là sự đau khổ. ",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: FontSizes.paragraph1, color: ColorName.black.shade500),
          ),
          image: AppIcons.logo,
          decoration: const PageDecoration(imagePadding: EdgeInsets.only(top: Space.superLarge)),
        ),
        PageViewModel(
          titleWidget: Text(
            "Không có ai muốn khổ đau cho chính mình.",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: FontSizes.headline1,
              color: ColorName.black,
            ),
          ),
          bodyWidget: Text(
            "Không có ai muốn khổ đau cho chính mình, muốn tìm kiếm về nó và muốn có nó, bởi vì nó là sự đau khổ. Không có ai muốn khổ đau cho chính mình, muốn tìm kiếm về nó và muốn có nó, bởi vì nó là sự đau khổ. Không có ai muốn khổ đau cho chính mình, muốn tìm kiếm về nó và muốn có nó, bởi vì nó là sự đau khổ. ",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: FontSizes.paragraph1, color: ColorName.black.shade500),
          ),
          image: AppIcons.logo,
          decoration: const PageDecoration(imagePadding: EdgeInsets.only(top: Space.superLarge)),
        ),
      ],
      isTopSafeArea: true,
      dotsDecorator: DotsDecorator(
        size: const Size.square(Space.mediumSmall),
        activeSize: const Size(Space.large, Space.mediumSmall),
        activeColor: Theme.of(context).colorScheme.secondary,
        color: ColorName.black.shade100,
        spacing: const EdgeInsets.symmetric(horizontal: Space.superSmall),
        activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Space.large)),
      ),
      showSkipButton: true,
      skip: const Text("Bỏ qua"),
      showNextButton: true,
      next: const Text("Tiếp tục"),
      nextStyle: Style.button,
      doneStyle: Style.button,
      done: const Text("Bắt đầu"),
      onDone: () {
        context.pushNamed('/login');
      },
    );
  }
}
