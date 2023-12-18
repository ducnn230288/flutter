import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';

import '/constants/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';

class WInput<T> extends StatefulWidget {
  final String label;
  final String name;
  final String value;
  final String? hintText;
  final String? subtitle;
  final bool space;
  final int maxLines;
  final int? maxLength;
  final int? minLength;
  final bool required;
  final bool enabled;
  final bool password;
  final bool stackedLabel;
  final bool focus;
  final ValueChanged<String>? onChanged;
  final Function(dynamic)? onTap;
  final dynamic onValidated;
  final String? icon;
  final Widget? suffix;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FormatNumberType formatNumberType;
  final String? rulesRequired;
  final double? height;
  final double? width;
  final EFormItemKeyBoard? keyBoard;

  const WInput({
    Key? key,
    this.label = '',
    this.value = '',
    this.subtitle,
    this.maxLines = 1,
    this.maxLength,
    this.minLength,
    this.required = true,
    this.enabled = true,
    this.password = false,
    this.stackedLabel = true,
    this.focus = false,
    this.onChanged,
    this.onValidated,
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
    this.height,
    this.width,
    this.keyBoard,
  }) : super(key: key);

  @override
  State<WInput> createState() => _WInputState<T>();
}

class _WInputState<T> extends State<WInput> {
  late final TextEditingController controller;
  late final OutlineInputBorder borderStyle = OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(CRadius.small)),
    borderSide: BorderSide(color: CColor.black.shade100, width: 1),
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
    if (widget.value != 'null') controller.setText(widget.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool inputFormatters = widget.keyBoard == EFormItemKeyBoard.number && widget.formatNumberType == FormatNumberType.inputFormatters;
    final height = widget.height != null ? ((widget.height! / CHeight.large) - 1) : 0;
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
                      style: TextStyle(color: CColor.danger),
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
        SizedBox(
          height: widget.height,
          width: widget.width,
          child: TextFormField(
            focusNode: focusNode,
            controller: controller,
            onTap: () {
              if (!widget.focus && widget.onTap != null) {
                widget.onTap!(controller.text);
              }
            },
            maxLength: widget.maxLength,
            readOnly: widget.onTap != null,
            textInputAction: widget.maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
            style: TextStyle(fontSize: CFontSize.body + (height * 3), color: CColor.black.shade700),
            onChanged: (String text) {
              if (inputFormatters) text = text.replaceAll('.', '');
              if (widget.onChanged != null) widget.onChanged!(text);
            },
            validator: (value) {
              BlocC cubit = context.read<BlocC<T>>();
              if (cubit.state.status != AppStatus.success && widget.required && value == '') {
                return (widget.rulesRequired ?? 'widgets.form.input.rulesRequired')
                    .tr(args: [('${widget.label != '' ? widget.label : widget.hintText}').toLowerCase()]);
              }
              if (value != '') {
                switch (widget.keyBoard) {
                  case EFormItemKeyBoard.email:
                    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!)) return 'Không đúng định dạng email';
                    return null;
                  case EFormItemKeyBoard.phone:
                    if (!RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$').hasMatch(value!) || value.length > 11) return 'Nhập sai định dạng số điện thoại';
                    return null;
                  case EFormItemKeyBoard.number:
                    if (value!.contains('-')) return 'Không được có dấu trừ';
                    if (double.tryParse(value.replaceAll('.', '')) == null || value.endsWith('.')) return 'Vui lòng nhập đúng định dạng số';
                    if (value[0] == '0') return 'Nhập sai định dạng số';
                    return null;
                  default:
                    break;
                }
                if (widget.minLength != null && value!.length < widget.minLength!) return 'Không được nhập dưới ${widget.minLength.toString()} ký tự';
                if (widget.onValidated != null && value != null) return widget.onValidated!(value);
              }

              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: visible,
            keyboardType: textInputType(),
            decoration: InputDecoration(
              counterText: widget.label != '' ? widget.label : widget.hintText,
              counterStyle: const TextStyle(fontSize: 0.5, color: Colors.transparent),
              hintText: widget.hintText ?? 'widgets.form.input.Enter'.tr(args: [widget.label.toLowerCase()]),
              hintStyle: TextStyle(
                fontSize: CFontSize.body + (height * 3),
                color: CColor.black.shade200,
                height: widget.height != null ? 1.9 : null,
              ),
              prefixIcon: widget.icon != null
                  ? Container(
                      padding: EdgeInsets.all(CSpace.medium + (height * 10)),
                      child: SvgPicture.asset(
                        widget.icon ?? '',
                        semanticsLabel: widget.hintText ?? widget.label,
                        width: 0,
                        theme: SvgTheme(currentColor: CColor.black.shade400),
                      ),
                    )
                  : null,
              suffixIconConstraints: BoxConstraints(
                minWidth: widget.height != null ? widget.height! - CSpace.medium - (height * 10) : CHeight.medium,
                minHeight: widget.height != null ? widget.height! - CSpace.medium - (height * 10) : CHeight.medium,
              ),
              suffixIcon: widget.password
                  ? InkWell(
                      canRequestFocus: false,
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
                      ? BlocBuilder<BlocC<T>, BlocS<T>>(
                          buildWhen: (bf, at) =>
                              (bf.value['fullTextSearch'] == '' && at.value['fullTextSearch'] != '') ||
                              (bf.value['fullTextSearch'] != '' && at.value['fullTextSearch'] == ''),
                          builder: (context, state) {
                            if (state.value['fullTextSearch'] == null ||
                                state.value['fullTextSearch'] == '' ||
                                (state.value['fullTextSearch'].runtimeType != String &&
                                    state.value['fullTextSearch']?['value'] == '') ||
                                controller.text == '') {
                              return Container();
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
                                color: CColor.black.shade300,
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
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                vertical: widget.maxLines > 1 ? CSpace.medium : -3,
                horizontal: CSpace.medium + (height * 10),
              ),
              filled: true,
            ),
            minLines: widget.maxLines,
            maxLines: widget.maxLines,
            inputFormatters: inputFormatters ? [ThousandFormatter()] : null,
          ),
        ),
        if (widget.subtitle != null)
          Text(widget.subtitle!, style: TextStyle(fontSize: CFontSize.footnote, color: CColor.black.shade400)),
        SizedBox(height: widget.space ? CSpace.small : 0),
      ],
    );
  }
  TextInputType? textInputType() {
    switch (widget.keyBoard) {
      case EFormItemKeyBoard.email:
        return TextInputType.emailAddress;
      case EFormItemKeyBoard.phone:
        return TextInputType.phone;
      case EFormItemKeyBoard.number:
        return const TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        );
      default:
        return null;
    }
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
