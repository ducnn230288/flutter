import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/constants/index.dart';
import '/core/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';

class WInput extends StatefulWidget {
  final String label;
  final String name;
  final String value;
  final String? hintText;
  final String? subtitle;
  final bool space;
  final int maxLines;
  final bool required;
  final bool enabled;
  final bool password;
  final bool number;
  final bool stackedLabel;
  final bool focus;
  final ValueChanged<String>? onChanged;
  final Function(dynamic)? onTap;
  final String? icon;
  final Widget? suffix;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FormatNumberType formatNumberType;
  final String? rulesRequired;

  const WInput({
    Key? key,
    this.label = '',
    this.value = '',
    this.subtitle,
    this.maxLines = 1,
    this.required = true,
    this.enabled = true,
    this.password = false,
    this.number = false,
    this.stackedLabel = true,
    this.focus = false,
    this.onChanged,
    this.onTap,
    this.icon,
    this.suffix,
    this.space = false,
    this.controller,
    this.focusNode,
    this.name = '',
    this.formatNumberType = FormatNumberType.inputFormatters,
    this.hintText,
    this.rulesRequired,
  }) : super(key: key);

  @override
  State<WInput> createState() => _WInputState();
}

class _WInputState extends State<WInput> {
  late final TextEditingController controller;
  final Color borderColor = const Color(0xFFc2c2c2);
  late final OutlineInputBorder borderStyle = OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(CRadius.small)),
    borderSide: BorderSide(color: borderColor, width: 1),
  );
  final OutlineInputBorder errorBorderStyle = OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(CRadius.small)),
    borderSide: BorderSide(color: CColor.danger, width: 1),
  );

  FocusNode focusNode = FocusNode();
  bool visible = false;

  @override
  void initState() {
    visible = widget.password;
    controller = widget.controller ?? TextEditingController();
    if (widget.focusNode != null) focusNode = widget.focusNode!;
    focusNode.addListener(() {
      if (widget.focus && focusNode.hasFocus && widget.onTap != null) {
        widget.onTap!(controller.text);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool inputFormatters = widget.number &&
        !widget.name.toLowerCase().contains('phone') &&
        widget.formatNumberType == FormatNumberType.inputFormatters;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != '' && widget.stackedLabel)
          Container(
            margin: const EdgeInsets.only(bottom: CSpace.mediumSmall),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: widget.label,
                  children: [
                    TextSpan(
                      text: widget.required ? ' *' : '',
                      style: TextStyle(color: CColor.red),
                    )
                  ],
                  style: TextStyle(
                    color: CColor.black,
                    fontSize: CFontSize.headline,
                    fontWeight: FontWeight.w600,
                    height: 22 / CFontSize.body,
                  )),
            ),
          ),
        TextFormField(
          focusNode: focusNode,
          controller: controller,
          onTap: () {
            if (!widget.focus && widget.onTap != null) {
              widget.onTap!(controller.text);
            }
          },
          readOnly: widget.onTap != null,
          textInputAction: TextInputAction.next,
          style: TextStyle(fontSize: CFontSize.body, color: CColor.black.shade700),
          onChanged: (String text) {
            if (inputFormatters) {
              text = text.replaceAll('.', '');
            }
            if (widget.onChanged != null) {
              widget.onChanged!(text);
            }
          },
          validator: (value) {
            if (widget.required && value == '') {
              return (widget.rulesRequired ?? 'widgets.form.input.rulesRequired')
                  .tr(args: [('${widget.label != '' ? widget.label : widget.hintText}').toLowerCase()]);
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: visible,
          keyboardType: widget.number
              ? TextInputType.number
              : widget.maxLines > 1
                  ? TextInputType.multiline
                  : null,
          decoration: InputDecoration(
            counterText: widget.label != '' ? widget.label : widget.hintText,
            counterStyle: const TextStyle(fontSize: 0.5, color: Colors.transparent),
            hintText: widget.hintText ?? 'widgets.form.input.Enter'.tr(args: [widget.label.toLowerCase()]),
            hintStyle: TextStyle(fontSize: CFontSize.body, color: CColor.black.shade200),
            prefixIcon: widget.icon != null
                ? Container(
                    padding: const EdgeInsets.all(CSpace.medium),
                    child: SvgPicture.asset(
                      widget.icon ?? '',
                      semanticsLabel: widget.hintText ?? widget.label,
                      width: 0,
                      color: CColor.black.shade400,
                    ),
                  )
                : null,
            suffixIcon: widget.password
                ? InkWell(
                    splashColor: CColor.primary.shade100,
                    onTap: () => setState(() {
                      visible = !visible;
                    }),
                    child: Icon(
                      visible ? Icons.visibility_off : Icons.visibility,
                      color: CColor.black.shade200,
                      semanticLabel: 'View',
                    ),
                  )
                : widget.name == 'fullTextSearch'
                    ? BlocBuilder<BlocC, BlocS>(
                        builder: (context, state) {
                          if (state.value['fullTextSearch'] == null ||
                              state.value['fullTextSearch'] == '' ||
                              (state.value['fullTextSearch'].runtimeType != String &&
                                  state.value['fullTextSearch']?['value'] == '') ||
                              controller.text == '') {
                            return const HSpacer(0);
                          }
                          return InkWell(
                            splashColor: CColor.primary.shade100,
                            onTap: () {
                              controller.clear();
                              if (widget.onChanged != null) {
                                widget.onChanged!('');
                              }
                            },
                            child: Icon(
                              Icons.cancel,
                              size: CFontSize.title3,
                              color: CColor.hintColor,
                              semanticLabel: 'Clear',
                            ),
                          );
                        },
                      )
                    : widget.suffix,
            border: borderStyle,
            focusedBorder: borderStyle,
            disabledBorder: borderStyle,
            enabledBorder: borderStyle,
            errorBorder: errorBorderStyle,
            focusedErrorBorder: errorBorderStyle,
            fillColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(
              vertical: widget.maxLines > 1 ? CSpace.medium : 0,
              horizontal: CSpace.medium,
            ),
            filled: true,
          ),
          minLines: widget.maxLines,
          maxLines: widget.maxLines,
          inputFormatters: inputFormatters ? [ThousandFormatter()] : null,
        ),
        if (widget.subtitle != null) Text(widget.subtitle!, style: const TextStyle(fontSize: CFontSize.footnote)),
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
