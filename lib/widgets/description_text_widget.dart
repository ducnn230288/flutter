import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DescriptionTextWidget extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const DescriptionTextWidget({
    Key? key,
    required this.text,
    this.style,
  }) : super(key: key);

  @override
  State<DescriptionTextWidget> createState() => _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  late String firstHalf;
  late String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.text.length > 100) {
      firstHalf = widget.text.substring(0, 100);
      secondHalf = widget.text.substring(100, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }

    return Container(
      child: secondHalf.isEmpty
          ? Text(
              firstHalf,
              style: widget.style,
            )
          : Column(
              children: <Widget>[
                InkWell(
                  child: Text(
                    flag
                        ? ("$firstHalf...${"widgets.description_text_widget.See more".tr()}")
                        : (firstHalf + secondHalf),
                    style: widget.style,
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}
