import 'package:flutter/material.dart';

import '/utils.dart';

class ModelForm {
  ModelForm({
    this.submit,
    this.textSubmit = '',
    items,
    colorSubmit,
  })  : items = items ?? [],
        colorSubmit = colorSubmit ?? AppThemes.primaryColor;

  Function? submit;
  String textSubmit;
  Color colorSubmit;
  List<ModelFormItem> items;

  factory ModelForm.fromJson(Map<String, dynamic> json) => ModelForm(
        submit: json["submit"],
        textSubmit: json["textSubmit"] ?? '',
        colorSubmit: json["colorSubmit"] ?? AppThemes.primaryColor,
        items: List<ModelFormItem>.from(json["items"].map((x) => ModelFormItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "submit": submit,
        "textSubmit": textSubmit,
        "colorSubmit": colorSubmit,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class ModelFormItem {
  ModelFormItem({
    this.name = '',
    this.type = '',
    this.label = '',
    this.value = '',
    this.maxLines = 1,
    this.required = false,
    this.enabled = true,
    this.password = false,
    this.number = false,
    this.placeholder = false,
    this.onTap,
    this.onFind,
    this.icon,
    this.suffix,
  });

  String name;
  String type;
  String label;
  dynamic value;
  int maxLines;
  bool required;
  bool enabled;
  bool password;
  bool number;
  bool placeholder;
  Function? onTap;
  Function? onFind;
  String? icon;
  String? suffix;

  factory ModelFormItem.fromJson(Map<String, dynamic> json) => ModelFormItem(
        name: json["name"] ?? '',
        type: json["type"] ?? '',
        label: json["label"] ?? '',
        value: json["value"] ?? '',
        maxLines: json["maxLines"] ?? 1,
        required: json["required"] ?? false,
        enabled: json["enabled"] ?? true,
        password: json["password"] ?? false,
        number: json["number"] ?? false,
        placeholder: json["placeholder"] ?? false,
        onTap: json["onTap"] ?? null,
        onFind: json["onFind"] ?? null,
        icon: json["icon"] ?? null,
        suffix: json["suffix"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "label": label,
        "value": value,
        "maxLines": maxLines,
        "required": required,
        "enabled": enabled,
        "password": password,
        "number": number,
        "placeholder": placeholder,
        "onTap": onTap,
        "onFind": onFind,
        "icon": icon,
        "suffix": suffix,
      };
}

class ModelOption {
  ModelOption({
    this.label = '',
    this.value = '',
  });

  String label;
  String value;

  factory ModelOption.fromJson(Map<String, dynamic> json) => ModelOption(
        label: json["label"] ?? '',
        value: json["value"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
      };
}
