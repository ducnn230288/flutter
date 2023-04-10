import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '/constants/index.dart';

class WInput extends StatefulWidget {
  final String label;
  final String name;
  final String value;
  final bool space;
  final int maxLines;
  final bool required;
  final bool enabled;
  final bool password;
  final bool number;
  final bool stackedLabel;
  final bool focus;
  final ValueChanged<String>? onChanged;
  final Function? onTap;
  final String? icon;
  final Widget? suffix;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const WInput({
    Key? key,
    this.label = '',
    this.value = '',
    this.maxLines = 1,
    this.required = true,
    this.enabled = true,
    this.password = false,
    this.number = false,
    this.stackedLabel = false,
    this.focus = false,
    this.onChanged,
    this.onTap,
    this.icon,
    this.suffix,
    this.space = false,
    this.controller,
    this.focusNode,
    this.name = '',
  }) : super(key: key);

  @override
  State<WInput> createState() => _WInputState();
}

class _WInputState extends State<WInput> {
  FocusNode focusNode = FocusNode();
  bool visible = false;

  @override
  void initState() {
    visible = widget.password;
    if (widget.focusNode != null) focusNode = widget.focusNode!;
    focusNode.addListener(() {
      if (widget.focus && focusNode.hasFocus && widget.onTap != null) {
        widget.onTap!();
      }
    });
    super.initState();
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
                        fontSize: CFontSize.paragraph1,
                      )),
                  const SizedBox(
                    height: CSpace.mediumSmall,
                  ),
                ],
              )
            : Container(),
        Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(CSpace.medium),
              boxShadow: [
                BoxShadow(color: CColor.black.shade50, blurRadius: CSpace.large / 3, spreadRadius: CSpace.large / 4)
              ]),
          child: TextFormField(
            focusNode: focusNode,
            controller: widget.controller,
            onTap: () {
              if (!widget.focus && widget.onTap != null) {
                widget.onTap!();
              }
            },
            readOnly: widget.onTap != null,
            textInputAction: TextInputAction.next,
            style: TextStyle(color: CColor.primary),
            onChanged: (String text) {
              if (widget.number && !widget.name.toLowerCase().contains('phone')) {
                text = text.replaceAll('.', '');
              }
              widget.onChanged!(text);
            },
            validator: (value) {
              if (widget.required && value == '') {
                return 'widgets.form.input.Required content'.tr();
              }
              return null;
            },
            obscureText: visible,
            keyboardType: widget.number ? TextInputType.number : null,
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: TextStyle(color: CColor.black.shade400, fontSize: CFontSize.paragraph1),
              prefixIcon: widget.icon != null
                  ? Container(
                      padding: const EdgeInsets.all(CSpace.medium),
                      child: SvgPicture.asset(
                        widget.icon ?? '',
                        semanticsLabel: widget.label,
                        width: 0,
                        color: CColor.black.shade400,
                      ),
                    )
                  : null,
              suffixIcon: widget.password
                  ? GestureDetector(
                      onTap: () => setState(() {
                        visible = !visible;
                      }),
                      child: Icon(
                        visible ? Icons.visibility : Icons.visibility_off,
                        color: CColor.black.shade200,
                      ),
                    )
                  : widget.suffix,
              enabled: widget.enabled,
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(CSpace.medium)),
                borderSide: BorderSide(color: CColor.primary, width: 0),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(CSpace.medium)),
                borderSide: BorderSide(color: CColor.primary.withOpacity(0.0), width: 0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(CSpace.medium)),
                borderSide: BorderSide(color: CColor.primary.withOpacity(widget.value != '' ? 0.3 : 0), width: 0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(CSpace.medium)),
                borderSide: BorderSide(color: CColor.danger, width: 0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(CSpace.medium)),
                borderSide: BorderSide(color: CColor.danger.withOpacity(0.5), width: 0),
              ),
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                vertical: widget.maxLines > 1 ? CSpace.medium : 0,
                horizontal: widget.icon != null ? 0 : 20,
              ),
              filled: true,
            ),
            minLines: 1,
            maxLines: widget.maxLines,
            inputFormatters:
                widget.number && !widget.name.toLowerCase().contains('phone') ? [ThousandFormatter()] : null,
          ),
        ),
        SizedBox(height: widget.space ? CSpace.large : 0),
      ],
    );
  }
}

class ThousandFormatter extends TextInputFormatter {
  static const separator = '.';

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String newValueText = newValue.text.replaceAll(separator, '');

    if (oldValue.text.endsWith(separator) && oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    int selectionIndex = newValue.text.length - newValue.selection.extentOffset;
    final chars = newValueText.split('');
    String newString = '';
    for (int i = chars.length - 1; i >= 0; i--) {
      if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1) {
        newString = separator + newString;
      }
      newString = chars[i] + newString;
    }

    return TextEditingValue(
      text: newString.toString(),
      selection: TextSelection.collapsed(
        offset: newString.length - selectionIndex,
      ),
    );
  }
}
