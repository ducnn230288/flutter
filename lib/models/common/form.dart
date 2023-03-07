import 'package:flutter/material.dart';

class ModelFormItem {
  ModelFormItem({
    required this.name,
    this.type = '',
    this.label = '',
    this.value = '',
    this.maxLines = 1,
    this.required = true,
    this.show = true,
    this.enabled = true,
    this.password = false,
    this.number = false,
    this.onTap,
    this.onFind,
    this.onChange,
    this.icon,
    this.suffix,
    this.items,
    this.format,
    this.api,
    this.itemSelect,
    this.showSearch = true,
    this.selectLabel,
    this.selectValue,
  });

  String name;
  String type;
  String label;
  dynamic value;
  int maxLines;
  bool required;
  bool show;
  bool enabled;
  bool password;
  bool number;
  Function? onTap;
  Function? onFind;
  Function? onChange;
  String? icon;
  Widget? suffix;
  List? items;
  Function? format;
  Function? api;
  Function? itemSelect;
  bool? showSearch;
  Function? selectLabel;
  Function? selectValue;

  factory ModelFormItem.fromJson(Map<String, dynamic> json) => ModelFormItem(
        name: json["name"] ?? '',
        type: json["type"] ?? '',
        label: json["label"] ?? '',
        value: json["value"] ?? '',
        maxLines: json["maxLines"] ?? 1,
        required: json["required"] ?? true,
        show: json["show"] ?? true,
        enabled: json["enabled"] ?? true,
        password: json["password"] ?? false,
        number: json["number"] ?? false,
        onTap: json["onTap"],
        onFind: json["onFind"],
        onChange: json["onChange"],
        icon: json["icon"],
        suffix: json["suffix"],
        items: json["items"] != null ? List<ModelOption>.from(json["items"].map((x) => ModelOption.fromJson(x))) : null,
        format: json["format"],
        api: json["api"],
        itemSelect: json["itemSelect"],
        showSearch: json["showSearch"] ?? true,
        selectLabel: json["selectLabel"],
        selectValue: json["selectValue"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "label": label,
        "value": value,
        "maxLines": maxLines,
        "required": required,
        "show": show,
        "enabled": enabled,
        "password": password,
        "number": number,
        "onTap": onTap,
        "onFind": onFind,
        "onChange": onChange,
        "icon": icon,
        "suffix": suffix,
        "items": items != null ? List<dynamic>.from(items!.map((x) => x.toJson())) : null,
        "format": format,
        "api": api,
        "itemSelect": itemSelect,
        "showSearch": showSearch,
        "selectLabel": selectLabel,
        "selectValue": selectValue,
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
