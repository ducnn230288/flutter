import 'package:flutter/material.dart';

import '/constants/index.dart';
import '/core/index.dart';

class CustomTabBar extends StatefulWidget {
  final List<String> title;
  final List<String>? code;
  final dynamic initial;
  final double height;
  final double? width;
  final double stroke;
  final double radius;
  final double indents;
  final double fontSize;
  final Color? fontColor;
  final Color? borderColor;
  final Color? selectTextColor;
  final Color? unSelectTextColor;
  final Color? selectBackgroundColor;
  final Color? unSelectBackgroundColor;
  final FontWeight? fontWeight;
  final EdgeInsets? margin;
  final Function(dynamic) onSelect;
  final int? onChangeIndex;

  const CustomTabBar(
      {super.key,
      this.height = 38,
      this.width,
      this.stroke = 1,
      this.radius = 5,
      this.fontSize = CFontSize.base,
      this.fontColor,
      this.borderColor,
      required this.title,
      this.selectTextColor,
      this.unSelectTextColor,
      this.selectBackgroundColor,
      this.unSelectBackgroundColor,
      required this.onSelect,
      required this.indents,
      this.fontWeight,
      this.code,
      this.initial,
      this.margin,
      this.onChangeIndex});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  int _index = 0;
  double _width = 0;

  @override
  void initState() {
    if (widget.initial != null) {
      widget.onSelect(widget.initial);
      for (int i = 0; i < widget.code!.length; i++) {
        if (widget.initial == widget.code![i]) {
          _index = i;
          break;
        }
      }
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomTabBar oldWidget) {
    if (widget.onChangeIndex != null) {
      setState(() {
        _index = widget.onChangeIndex!;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    _width = (widget.width ?? MediaQuery.of(context).size.width - 2 * widget.indents - 2 * widget.stroke) /
        widget.title.length;
    return Container(
      height: widget.height,
      width: widget.width,
      margin: widget.margin,
      decoration: BoxDecoration(
          border: Border.all(color: widget.borderColor ?? CColor.black.shade200, width: widget.stroke),
          borderRadius: BorderRadius.circular(widget.radius),
          color: widget.unSelectBackgroundColor ?? Colors.white),
      child: Stack(
        children: [
          AnimatedContainer(
            width: _width,
            margin: EdgeInsets.only(left: _index * _width),
            decoration: BoxDecoration(
                color: widget.selectBackgroundColor ?? CColor.black.shade100.withOpacity(0.2),
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(_index == 0 ? 0.9 * widget.radius : 0),
                  right: Radius.circular(_index == widget.title.length - 1 ? 0.9 * widget.radius : 0),
                )),
            duration: const Duration(milliseconds: 200),
            curve: Curves.linear,
          ),
          Row(
            children: [
              ...List.generate(widget.title.length, (index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _index = index;
                    });
                    if (widget.code != null) {
                      widget.onSelect(widget.code![index]);
                      return;
                    }
                    widget.onSelect(index);
                  },
                  child: Container(
                    height: widget.height,
                    width: _width,
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        widget.title[index],
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: widget.fontSize,
                            color: index == _index
                                ? widget.selectTextColor ?? Colors.black
                                : widget.unSelectTextColor ?? CColor.black.shade200,
                            fontWeight: widget.fontWeight),
                      ),
                    ),
                  ),
                );
              })
            ],
          ),
          Row(
            children: [
              ...List.generate(widget.title.length - 1, (index) {
                return Container(
                  margin: EdgeInsets.only(left: _width - widget.stroke),
                  child: line(
                    height: widget.height,
                    width: widget.stroke,
                    color: widget.borderColor,
                  ),
                );
              })
            ],
          )
        ],
      ),
    );
  }
}
