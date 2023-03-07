import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '/constants/index.dart';
import './input.dart';

class WidgetDate extends StatelessWidget {
  final String label;
  final String value;
  final bool space;
  final int maxLines;
  final bool required;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final String? icon;
  final String? format;
  final TextEditingController controller;

  const WidgetDate({
    Key? key,
    this.label = '',
    this.value = '',
    this.onChanged,
    this.required = false,
    this.enabled = true,
    this.space = false,
    this.maxLines = 1,
    this.icon,
    this.format = 'dd/MM/yyyy',
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetInput(
      controller: controller,
      label: label,
      value: value,
      space: space,
      maxLines: maxLines,
      required: required,
      enabled: enabled,
      onTap: () {
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              content: SingleChildScrollView(
                  child: SizedBox(
                width: 250,
                child: SfDateRangePicker(
                  headerStyle: DateRangePickerHeaderStyle(textStyle: Style.title),
                  view: DateRangePickerView.month,
                  selectionMode: DateRangePickerSelectionMode.single,
                  onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                    // _selectedDate = DateFormat('dd MMMM, yyyy').format(args.value);

                    SchedulerBinding.instance!.addPostFrameCallback((duration) {
                      if (onChanged != null) {
                        initializeDateFormatting();
                        controller.text = DateFormat('dd MMMM, yyyy', 'vi').format(args.value);
                        onChanged!(args.value.toString());
                        Navigator.of(context).pop();
                        FocusScope.of(context).unfocus();
                      }
                    });
                  },
                ),
              )),
              contentPadding: const EdgeInsets.all(Space.small),
              actions: <Widget>[
                TextButton(
                  child: const Text('Huỷ bỏ'),
                  onPressed: () {
                    controller.clear();
                    onChanged!('');
                    Navigator.of(context).pop();
                    FocusScope.of(context).unfocus();
                  },
                )
              ],
            );
          },
        );
      },
      icon: icon,
    );
  }
}
