import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/constants/index.dart';

class WidgetInput extends StatefulWidget {
  final String label;
  final bool space;
  final String value;
  final int maxLines;
  final bool required;
  final bool enabled;
  final bool password;
  final bool number;
  final bool placeholder;
  final bool stackedLabel;
  final ValueChanged<String>? onChanged;
  final Function? onTap;
  final String? icon;
  final String? suffix;

  const WidgetInput({
    Key? key,
    this.label = '',
    this.value = '',
    this.maxLines = 1,
    this.required = true,
    this.enabled = true,
    this.password = false,
    this.number = false,
    this.placeholder = true,
    this.stackedLabel = false,
    this.onChanged,
    this.onTap,
    this.icon,
    this.suffix,
    this.space = false,
  }) : super(key: key);

  @override
  WidgetInputState createState() => WidgetInputState();
}

class WidgetInputState extends State<WidgetInput> {
  FocusNode focusNode = FocusNode();
  String value = '';
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.value;
    value = widget.value;
    focusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  setValue(String text) {
    setState(() {
      _controller.text = text;
      value = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.stackedLabel
            ? Column(
                children: [
                  Text(widget.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: FontSizes.paragraph1,
                      )),
                  const SizedBox(
                    height: Space.mediumSmall,
                  ),
                ],
              )
            : Container(),
        Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(Space.medium),
              boxShadow: [
                BoxShadow(color: ColorName.black.shade50, blurRadius: Space.large / 3, spreadRadius: Space.large / 4)
              ]),
          child: TextFormField(
            onTap: () {
              if (widget.onTap != null) {
                widget.onTap!();
              }
            },
            controller: _controller,
            readOnly: widget.onTap != null,
            focusNode: focusNode,
            textInputAction: TextInputAction.next,
            style: TextStyle(color: ColorName.primary),
            onChanged: (String text) {
              value = text;
              widget.onChanged!(text);
            },
            validator: (value) {
              if (widget.required && value == '') {
                return 'Required content';
              }
              return null;
            },
            obscureText: widget.password,
            keyboardType: widget.number ? TextInputType.number : null,
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: TextStyle(color: ColorName.black.shade400, fontSize: FontSizes.paragraph1),
              prefixIcon: widget.icon != ''
                  ? Container(
                      padding: const EdgeInsets.all(Space.medium),
                      child: SvgPicture.asset(
                        widget.icon ?? '',
                        semanticsLabel: widget.label,
                        width: 0,
                        color: focusNode.hasFocus ? ColorName.primary : ColorName.black.shade400,
                      ),
                    )
                  : null,
              suffixText: widget.suffix,
              enabled: widget.enabled,
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(Space.medium)),
                borderSide: BorderSide(color: ColorName.primary, width: 0),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(Space.medium)),
                borderSide: BorderSide(color: ColorName.primary.withOpacity(0.0), width: 0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(Space.medium)),
                borderSide: BorderSide(color: ColorName.primary.withOpacity(value != '' ? 0.3 : 0), width: 0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(Space.medium)),
                borderSide: BorderSide(color: ColorName.danger, width: 0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(Space.medium)),
                borderSide: BorderSide(color: ColorName.danger.withOpacity(0.5), width: 0),
              ),
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              filled: true,
            ),
            minLines: 1,
            maxLines: widget.maxLines,
          ),
        ),
        SizedBox(height: widget.space ? Space.large : 0),
      ],
    );
  }
}
