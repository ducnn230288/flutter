import 'package:flutter/material.dart';

class MFilter {
  MFilter({
    IconData? icon,
    String? label,
    dynamic value,
    String? keyValue,
    Function()? onTap,
    Color? color,
    Widget? child,
    bool? changeLabel,
  }) {
    _label = label;
    _value = value;
    _keyValue = keyValue;
    _onTap = onTap;
    _icon = icon;
    _color = color;
    _child = child;
    _changeLabel = changeLabel;
  }

  MFilter.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
    _keyValue = json['keyValue'];
    _onTap = json['onTap'];
    _icon = json['icon'];
    _color = json['color'];
    _child = json['child'];
    _changeLabel = json['changeLabel'];
  }

  String? _label;
  dynamic _value;
  String? _keyValue;
  Function()? _onTap;
  IconData? _icon;
  Color? _color;
  Widget? _child;
  bool? _changeLabel;

  MFilter copyWith({
    String? label,
    dynamic value,
    String? keyValue,
    Function()? onTap,
    IconData? icon,
    Widget? child,
    bool? changeLabel,
    bool? selected,
  }) =>
      MFilter(
        label: label ?? _label,
        value: value ?? _value,
        keyValue: keyValue ?? _keyValue,
        onTap: onTap ?? _onTap,
        icon: icon ?? _icon,
        child: child ?? _child,
        changeLabel: changeLabel ?? _changeLabel,
      );

  String get label => _label ?? '';

  dynamic get value => _value ?? '';

  String? get keyValue => _keyValue;

  Function()? get onTap => _onTap;

  IconData? get icon => _icon;

  Color? get color => _color;

  Widget? get child => _child;

  bool get changeLabel => _changeLabel ?? false;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    map['keyValue'] = _keyValue;
    map['onTap'] = _onTap;
    map['icon'] = _icon;
    map['color'] = _color;
    map['child'] = _child;
    return map;
  }
}
