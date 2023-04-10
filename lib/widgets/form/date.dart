import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:uberental/utils/dialogs.dart';

import '/constants/index.dart';
import './input.dart';

class WDate extends StatefulWidget {
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

  const WDate({
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
  State<WDate> createState() => _WDateState();
}

class _WDateState extends State<WDate> {
  FocusNode focusNode = FocusNode();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WInput(
      controller: widget.controller,
      label: widget.label,
      value: widget.value,
      space: widget.space,
      maxLines: widget.maxLines,
      required: widget.required,
      enabled: widget.enabled,
      focus: true,
      focusNode: focusNode,
      onTap: () {
        focusNode.unfocus();
        return showDialog<void>(
          context: context,
          // barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 250,
                  child: SfDateRangePicker(
                    initialSelectedDate: selectedDate,
                    headerStyle: DateRangePickerHeaderStyle(textStyle: CStyle.title),
                    view: DateRangePickerView.month,
                    selectionMode: DateRangePickerSelectionMode.single,
                    onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                      SchedulerBinding.instance.addPostFrameCallback((duration) async {
                        if (widget.onChanged != null) {
                          selectedDate = args.value;
                          initializeDateFormatting();
                          widget.controller.text = DateFormat('dd MMMM, yyyy', 'vi').format(args.value);
                          widget.onChanged!(args.value.toString());
                          await UDialog().delay();
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        }
                      });
                    },
                  ),
                )),
              contentPadding: const EdgeInsets.all(CSpace.small),
            );
          },
        );
      },
      icon: widget.icon,
    );
  }

  @override
  void initState() {
    if (widget.value != '') {
      selectedDate = DateTime.parse(widget.value);
    }
    super.initState();
  }
}
