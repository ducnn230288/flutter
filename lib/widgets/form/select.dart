import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/models.dart';
import '/utils.dart';

class WidgetSelect extends StatelessWidget {
  final String label;
  final bool space;
  final icon;
  final suffix;
  final onChanged;
  final onFind;
  final bool required;
  final bool enabled;
  final ModelOption? value;

  WidgetSelect({
    this.label = '',
    this.value,
    this.icon,
    this.suffix,
    this.onChanged,
    this.required = false,
    this.enabled = true,
    this.space = false,
    this.onFind,
  });
  @override
  Widget build(BuildContext context) {
    Widget _customDropDown(BuildContext context, ModelOption? item) {
      return (item != null && item.label != null)
          ? Text(
              item.label,
              style: TextStyle(color: Theme.of(context).primaryColor),
            )
          : Text('');
    }

    return Column(
      children: [
        Container(
          height: 40 + (AppThemes.gap / 4),
          decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(10.0), boxShadow: [
            BoxShadow(color: AppThemes.lightColor, blurRadius: AppThemes.gap / 3, spreadRadius: AppThemes.gap / 4)
          ]),
          child: DropdownSearch<ModelOption>(
            selectedItem: value,
            enabled: enabled,
            onChanged: onChanged,
            autoValidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (required && value == null) return ('Required content');
              return null;
            },
            popupProps: const PopupProps.bottomSheet(),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: label,
                prefixIcon: icon != ''
                    ? Container(
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset(
                          icon ?? '',
                          semanticsLabel: label,
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
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            filterFn: (user, filter) => onFind(filter),
            // dropdownBuilder: _customDropDown,
          ),
        ),
        SizedBox(height: space ? AppThemes.gap : 0),
      ],
    );
  }
}
