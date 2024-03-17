import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '/core/index.dart';
import '/utils/index.dart';

class WTime<T> extends StatefulWidget {
  final String label;
  final String value;
  final String? subtitle;
  final String? hintText;
  final bool space;
  final int maxLines;
  final bool required;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final String? icon;
  final TextEditingController controller;
  final double? height;
  final double? width;

  const WTime({
    super.key,
    this.label = '',
    this.value = '',
    this.subtitle = '',
    this.onChanged,
    this.required = false,
    this.enabled = true,
    this.space = false,
    this.maxLines = 1,
    this.icon,
    required this.controller,
    this.hintText,
    this.height,
    this.width,
  });

  @override
  State<WTime> createState() => _WTimeState<T>();
}

class _WTimeState<T> extends State<WTime> {
  FocusNode focusNode = FocusNode();
  TimeOfDay timeOfDay = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return WInput<T>(
      height: widget.height,
      width: widget.width,
      controller: widget.controller,
      label: widget.label,
      value: widget.value,
      subtitle: widget.subtitle,
      hintText: widget.hintText ?? 'widgets.form.input.Choose'.tr(args: [widget.label.toLowerCase()]),
      space: widget.space,
      maxLines: widget.maxLines,
      required: widget.required,
      enabled: widget.enabled,
      focus: true,
      focusNode: focusNode,
      onTap: (text) async {
        focusNode.unfocus();
        TimeOfDay? pickedTime = await showTimePicker(
          initialTime: timeOfDay,
          context: context,
          helpText: widget.label,
        );
        if (pickedTime != null && widget.onChanged != null && context.mounted) {
          if (context.mounted) {
            timeOfDay = pickedTime;
            final String dateTime = DateFormat('HH:mm').parse(pickedTime.format(context)).toIso8601String();
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
    if (widget.value != '') {
      timeOfDay = TimeOfDay.fromDateTime(DateTime.parse(widget.value));
    }
    super.initState();
  }
}
