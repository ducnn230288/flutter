import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/utils.dart';

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
    this.required = false,
    this.enabled = true,
    this.password = false,
    this.number = false,
    this.placeholder = false,
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
                        fontSize: 14,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              )
            : Container(),
        Container(
          decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(10.0), boxShadow: [
            BoxShadow(color: AppThemes.lightColor, blurRadius: AppThemes.gap / 3, spreadRadius: AppThemes.gap / 4)
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
            style: TextStyle(color: AppThemes.primaryColor),
            onChanged: (String text) {
              value = text;
              widget.onChanged!(text);
            },
            validator: (value) {
              if (widget.required && value == '') return ('Required content');
              // else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) return "Email format incorrect";
              return null;
            },
            obscureText: widget.password,
            keyboardType: widget.number ? TextInputType.number : null,
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: TextStyle(color: AppThemes.hintColor, fontSize: 14),
              prefixIcon: widget.icon != ''
                  ? Container(
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        widget.icon ?? '',
                        semanticsLabel: widget.label,
                        width: 10,
                        color: focusNode.hasFocus ? AppThemes.primaryColor : AppThemes.hintColor,
                      ),
                    )
                  : null,
              suffixText: widget.suffix,
              enabled: widget.enabled,
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: AppThemes.primaryColor, width: 1.0),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: AppThemes.primaryColor.withOpacity(0.0), width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: AppThemes.primaryColor.withOpacity(value != '' ? 0.3 : 0), width: 1.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: AppThemes.accentColor, width: 1.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: AppThemes.accentColor.withOpacity(0.5), width: 1.0),
              ),
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
              filled: true,
            ),
            minLines: 1,
            maxLines: widget.maxLines,
          ),
        ),
        SizedBox(height: widget.space ? AppThemes.gap : 0),
      ],
    );
  }
}
