import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '/constants/index.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        ...List.generate(3, (index) {
          return PageViewModel(
            titleWidget: Container(
              alignment: Alignment.topLeft,
              child: Text(
                "introduction.Title.$index".tr(),
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: CFontSize.xl3, color: CColor.black),
              ),
            ),
            bodyWidget: Text(
              "introduction.Content.$index".tr(),
              textAlign: TextAlign.justify,
              style: TextStyle(color: CColor.black.shade500),
            ),
            image: SvgPicture.asset('assets/svgs/splash/$index.svg'),
            decoration: const PageDecoration(imagePadding: EdgeInsets.only(top: CSpace.xl5)),
          );
        }),
      ],
      dotsDecorator: DotsDecorator(
        size: const Size.square(CSpace.base),
        activeSize: const Size(CSpace.xl3, CSpace.base),
        activeColor: Theme.of(context).colorScheme.secondary,
        color: CColor.black.shade100,
        spacing: const EdgeInsets.symmetric(horizontal: CSpace.xs),
        activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CSpace.xl3)),
      ),
      showSkipButton: true,
      skip: Text("pages.login.introduction.Skip".tr()),
      showNextButton: true,
      next: Text("pages.login.introduction.Next".tr()),
      nextStyle: CStyle.button,
      doneStyle: CStyle.button,
      done: Text("pages.login.introduction.Get started".tr()),
      onDone: () => context.goNamed(CRoute.login),
    );
  }
}
