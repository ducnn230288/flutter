import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/utils/index.dart';
import './input.dart';

class WTime extends StatefulWidget {
  final String label;
  final String value;
  final bool space;
  final int maxLines;
  final bool required;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final String? icon;
  final TextEditingController controller;

  const WTime({
    Key? key,
    this.label = '',
    this.value = '',
    this.onChanged,
    this.required = false,
    this.enabled = true,
    this.space = false,
    this.maxLines = 1,
    this.icon,
    required this.controller,
  }) : super(key: key);

  @override
  State<WTime> createState() => _WTimeState();
}

class _WTimeState extends State<WTime> {
  FocusNode focusNode = FocusNode();
  TimeOfDay timeOfDay = TimeOfDay.now();

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
      onTap: () async {
        focusNode.unfocus();
        TimeOfDay? pickedTime = await showTimePicker(
          initialTime: timeOfDay,
          context: context,
          // cancelText: '',
          helpText: widget.label,
        );
        if (pickedTime != null && widget.onChanged != null && context.mounted) {
          if (context.mounted) {
            timeOfDay = pickedTime;
            final String format = pickedTime.format(context).contains('M') ? 'hh:mm a' : 'hh:mm';
            final String dateTime = DateFormat(format).parse(pickedTime.format(context)).toIso8601String();
            widget.controller.text = Convert.hours(dateTime);
            widget.onChanged!(dateTime);
          }
        }
      },
      icon: widget.icon,
    );
  }

  @override
  void initState() {
    if (widget.value != ''){
      timeOfDay = TimeOfDay.fromDateTime(DateTime.parse(widget.value));
    }
    super.initState();
  }
}
