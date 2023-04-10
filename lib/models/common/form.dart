import 'package:flutter/material.dart';

class MFormItem {
  MFormItem({
    this.name = '',
    this.type = '',
    this.label = '',
    this.value = '',
    this.code = '',
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
    this.maxQuantity = 1,
    this.minQuantity = 1,
    this.child,
    this.dataType,
  });

  String name;
  String type;
  String label;
  dynamic value;
  dynamic code;
  int maxLines;
  bool required;
  bool show;
  bool enabled;
  bool password;
  bool number;
  Function? onTap;
  Function? onFind;
  Function(dynamic)? onChange;
  String? icon;
  Widget? suffix;
  List<MOption>? items;
  Function? format;
  Function(Map<String, dynamic> value, int page, int size, Map<String, dynamic> sort)? api;
  Function(dynamic content, int index)? itemSelect;
  bool? showSearch;
  Function? selectLabel;
  Function? selectValue;
  int minQuantity;
  int maxQuantity;
  Widget? child;
  DataType? dataType;

  factory MFormItem.fromJson(Map<String, dynamic> json) => MFormItem(
        name: json["name"] ?? '',
        type: json["type"] ?? '',
        label: json["label"] ?? '',
        value: json["value"] ?? '',
        code: json["code"] ?? '',
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
        items: json["items"],
        format: json["format"],
        api: json["api"],
        itemSelect: json["itemSelect"],
        showSearch: json["showSearch"] ?? true,
        selectLabel: json["selectLabel"],
        selectValue: json["selectValue"],
        minQuantity: json["minQuantity"],
        maxQuantity: json["maxQuantity"],
        child: json["child"],
        dataType: json["dataType"] ?? DataType.normal,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "label": label,
        "value": value,
        "code": code,
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
        "items": items != null ? List<MOption>.from(items!.map((x) => x.toJson())) : null,
        "format": format,
        "api": api,
        "itemSelect": itemSelect,
        "showSearch": showSearch,
        "selectLabel": selectLabel,
        "selectValue": selectValue,
        "minQuantity": minQuantity,
        "maxQuantity": maxQuantity,
        "child": child,
        "dataType": dataType,
      };
}

class MOption {
  MOption({
    this.label = '',
    this.value = '',
  });

  String label;
  String value;
  factory MOption.fromJson(Map<String, dynamic> json) => MOption(
        label: json["label"] ?? '',
        value: json["value"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
      };
}

enum DataType { phone, status, separation, normal, column, button, copy, image }
