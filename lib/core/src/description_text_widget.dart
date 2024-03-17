import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '/constants/index.dart';

class DescriptionTextWidget extends StatefulWidget {
  final String text;
  final int trim;
  final TextStyle? style;
  final TextAlign? textAlign;

  const DescriptionTextWidget({
    super.key,
    required this.text,
    this.style,
    this.trim = 100,
    this.textAlign,
  });

  @override
  State<DescriptionTextWidget> createState() => _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  late String firstHalf;
  late String secondHalf;
  late final TextStyle extendStyle;
  bool flag = true;

  @override
  void initState() {
    extendStyle = TextStyle(color: Colors.blue, fontSize: widget.style?.fontSize, fontWeight: FontWeight.w400);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.text.length > widget.trim + 1) {
      firstHalf = widget.text.substring(0, widget.trim - 1);
      secondHalf = widget.text.substring(widget.trim - 1, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = '';
    }
    return secondHalf.isEmpty
        ? Text(
            firstHalf,
            style: widget.style,
            textAlign: widget.textAlign,
          )
        : InkWell(
            splashColor: CColor.primary.shade100,
            child: Text.rich(
              TextSpan(
                text: flag ? firstHalf : (firstHalf + secondHalf),
                style: widget.style,
                children: [
                  TextSpan(
                    text: flag ? '...${"widgets.description_text_widget.See more".tr()}' : '',
                    style: extendStyle,
                  ),
                ],
              ),
              textAlign: widget.textAlign,
            ),
            onTap: () {
              if (widget.text.length > widget.trim) {
                setState(() {
                  flag = !flag;
                });
              }
            },
          );
  }
}
