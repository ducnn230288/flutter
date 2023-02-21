import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/models.dart';
import '/utils.dart';

class WidgetSelect extends StatefulWidget {
  final String label;
  final bool space;
  final icon;
  final suffix;
  final onChanged;
  final onFind;
  final bool required;
  final bool enabled;
  ModelOption? value;
  List<ModelOption>? items;

  WidgetSelect(
      {this.label = '',
      this.value,
      this.icon,
      this.suffix,
      this.onChanged,
      this.required = false,
      this.enabled = true,
      this.space = false,
      this.onFind,
      this.items});

  @override
  State<WidgetSelect> createState() => _WidgetSelectState();
}

class _WidgetSelectState extends State<WidgetSelect> {
  ModelOption? value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(10.0), boxShadow: [
            BoxShadow(color: AppThemes.lightColor, blurRadius: AppThemes.gap / 3, spreadRadius: AppThemes.gap / 4)
          ]),
          child: DropdownSearch<ModelOption>(
            items: widget.items ?? [],
            selectedItem: widget.value,
            itemAsString: (ModelOption u) => u.label,
            enabled: widget.enabled,
            onChanged: (ModelOption? text) {
              setState(() {
                value = text;
              });
              widget.onChanged!(text!.value);
            },
            autoValidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (widget.required && value == null) return ('Required content');
              return null;
            },
            popupProps: const PopupProps.bottomSheet(),
            dropdownDecoratorProps: DropDownDecoratorProps(
              baseStyle: TextStyle(color: AppThemes.primaryColor),
              dropdownSearchDecoration: InputDecoration(
                labelText: widget.label,
                prefixIcon: widget.icon != ''
                    ? Container(
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset(
                          widget.icon ?? '',
                          semanticsLabel: widget.label,
                          width: 10,
                        ),
                      )
                    : null,
                labelStyle: TextStyle(color: AppThemes.hintColor, fontSize: 14),
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
                  borderSide:
                      BorderSide(color: AppThemes.primaryColor.withOpacity(value != null ? 0.3 : 0), width: 1.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: AppThemes.accentColor, width: 1.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: AppThemes.accentColor.withOpacity(0.5), width: 1.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            // filterFn: (user, filter) => onFind(filter),
          ),
        ),
        SizedBox(height: widget.space ? AppThemes.gap : 0),
      ],
    );
  }
}
