import 'package:flutter/material.dart';

import '../../constants/index.dart';

class CustomCheckbox extends StatefulWidget {
  final String? name;
  final double? size;
  final double? iconSize;
  final double strokeRadius;
  final Function onChanged;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? strokeColor;
  final IconData? icon;
  final int? index;
  final double stroke;
  final bool isChecked;
  final double topMargin;
  final double bottomMargin;
  final double leftMargin;
  final double rightMargin;
  final bool disable;

  const CustomCheckbox({
    Key? key,
    this.size = 25,
    this.strokeRadius = 0,
    this.iconSize,
    this.index,
    required this.onChanged,
    this.backgroundColor,
    this.iconColor,
    this.icon,
    this.strokeColor,
    required this.isChecked,
    this.stroke = 1.5,
    this.topMargin = 0,
    this.bottomMargin = 0,
    this.leftMargin = 0,
    this.rightMargin = 0,
    this.name,
    this.disable = false,
  }) : super(key: key);

  @override
  State<CustomCheckbox> createState() => CustomCheckboxState();
}

class CustomCheckboxState extends State<CustomCheckbox> {
  bool _isChecked = false;

  void enableCheckBox() {
    setState(() {
      _isChecked = true;
    });
  }

  void disableCheckBox() {
    setState(() {
      _isChecked = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  void didUpdateWidget(covariant CustomCheckbox oldWidget) {
    setState(() {
      _isChecked = widget.isChecked;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: CColor.primary.shade100,
      onTap: () {
        if (widget.disable && _isChecked) return;
        setState(() {
          _isChecked = !_isChecked;
          if (widget.index != null) {
            widget.onChanged(_isChecked, widget.index);
          }
          if (widget.name != null) {
            widget.onChanged(_isChecked, widget.name);
          } else {
            widget.onChanged(_isChecked);
          }
        });
      },
      child: AnimatedContainer(
          height: widget.size,
          width: widget.size,
          duration: const Duration(milliseconds: 1000),
          margin: EdgeInsets.fromLTRB(widget.leftMargin, widget.topMargin, widget.rightMargin, widget.bottomMargin),
          curve: Curves.fastLinearToSlowEaseIn,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.strokeRadius),
              color: _isChecked ? widget.backgroundColor ?? CColor.primary : Colors.transparent,
              border: Border.all(
                  width: widget.stroke,
                  color: _isChecked
                      ? widget.backgroundColor ?? CColor.primary
                      : widget.strokeColor ?? CColor.black.shade300)),
          child: _isChecked
              ? Center(
                  child: Icon(
                    widget.icon ?? Icons.check,
                    color: widget.iconColor ?? Colors.white,
                    size: widget.iconSize ?? widget.size! * 0.8,
                  ),
                )
              : null),
    );
  }
}
