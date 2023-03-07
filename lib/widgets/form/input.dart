import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/constants/index.dart';

class WidgetInput extends StatelessWidget {
  final String label;
  final String value;
  final bool space;
  final int maxLines;
  final bool required;
  final bool enabled;
  final bool password;
  final bool number;
  final bool stackedLabel;
  final ValueChanged<String>? onChanged;
  final Function? onTap;
  final String? icon;
  final Widget? suffix;
  final TextEditingController? controller;

  const WidgetInput({
    Key? key,
    this.label = '',
    this.value = '',
    this.maxLines = 1,
    this.required = true,
    this.enabled = true,
    this.password = false,
    this.number = false,
    this.stackedLabel = false,
    this.onChanged,
    this.onTap,
    this.icon,
    this.suffix,
    this.space = false,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        stackedLabel
            ? Column(
                children: [
                  Text(label,
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
            controller: controller,
            onTap: () {
              if (onTap != null) {
                onTap!();
              }
            },
            readOnly: onTap != null,
            textInputAction: TextInputAction.next,
            style: TextStyle(color: ColorName.primary),
            onChanged: (String text) {
              onChanged!(text);
            },
            validator: (value) {
              if (required && value == '') {
                return 'Required content';
              }
              return null;
            },
            obscureText: password,
            keyboardType: number ? TextInputType.number : null,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: ColorName.black.shade400, fontSize: FontSizes.paragraph1),
              prefixIcon: icon != null
                  ? Container(
                      padding: const EdgeInsets.all(Space.medium),
                      child: SvgPicture.asset(
                        icon ?? '',
                        semanticsLabel: label,
                        width: 0,
                        color: ColorName.black.shade400,
                      ),
                    )
                  : null,
              suffixIcon: suffix,
              enabled: enabled,
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
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: icon != null ? 0 : 20),
              filled: true,
            ),
            minLines: 1,
            maxLines: maxLines,
          ),
        ),
        SizedBox(height: space ? Space.large : 0),
      ],
    );
  }
}
