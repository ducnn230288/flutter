import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/constants/index.dart';
import '/models/index.dart';

class WidgetSelect extends StatelessWidget {
  final String label;
  final bool space;
  final String? icon;
  final Function? onChanged;
  final Function? onFind;
  final bool required;
  final bool enabled;
  final ModelOption? value;
  final List<ModelOption>? items;

  const WidgetSelect(
      {super.key,
      this.label = '',
      this.value,
      this.icon,
      this.onChanged,
      this.required = false,
      this.enabled = true,
      this.space = false,
      this.onFind,
      this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(Space.medium),
              boxShadow: [
                BoxShadow(color: ColorName.black.shade50, blurRadius: Space.large / 3, spreadRadius: Space.large / 4)
              ]),
          child: DropdownSearch<ModelOption>(
            items: items ?? [],
            selectedItem: value,
            itemAsString: (ModelOption u) => u.label,
            enabled: enabled,
            onChanged: (ModelOption? text) {
              onChanged!(text!.value);
            },
            autoValidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (required && value == null) return ('Required content');
              return null;
            },
            // popupProps: const PopupProps.bottomSheet(),
            dropdownDecoratorProps: DropDownDecoratorProps(
              baseStyle: TextStyle(color: ColorName.primary),
              dropdownSearchDecoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(color: ColorName.black.shade400, fontSize: FontSizes.paragraph1),
                prefixIcon: icon != ''
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
                  borderSide: BorderSide(color: ColorName.primary.withOpacity(value != null ? 0.3 : 0), width: 0),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(Space.medium)),
                  borderSide: BorderSide(color: ColorName.danger, width: 0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(Space.medium)),
                  borderSide: BorderSide(color: ColorName.danger.withOpacity(0.5), width: 0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            // filterFn: (user, filter) => onFind(filter),
          ),
        ),
        SizedBox(height: space ? Space.large : 0),
      ],
    );
  }
}
