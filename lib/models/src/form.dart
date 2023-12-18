import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

enum EFormItemType { select, date, time, upload, selectMultiple, title, separation, input, checkbox, map }
enum EFormItemKeyBoard { number, phone, email }

class MFormItem {
  MFormItem({
    this.name = '',
    this.type = EFormItemType.input,
    this.label = '',
    this.subtitle,
    this.hintText,
    this.value = '',
    this.code = '',
    this.maxLines = 1,
    this.maxLength,
    this.minLength,
    this.required = true,
    this.show = true,
    this.enabled = true,
    this.password = false,
    this.showClose = false,
    this.keyBoard,
    this.onTap,
    this.onCondition,
    this.onFind,
    this.onChange,
    this.onValidator,
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
    this.prefix,
    this.child,
    this.dataType,
    this.selectDateType = SelectDateType.full,
    this.uploadType = UploadType.multiple,
    this.formatNumberType = FormatNumberType.inputFormatters,
    this.stackedLabel = true,
    this.bold = false,
    this.maxCountUpload,
    this.color,
    this.description,
    this.mode = DateRangePickerSelectionMode.single,
    this.showTime = false,
  });

  String name;
  EFormItemType type;
  String label;
  String? subtitle;
  String? hintText;
  dynamic value;
  dynamic code;
  int maxLines;
  int? maxLength;
  int? minLength;
  bool required;
  bool show;
  bool showClose;
  bool enabled;
  bool password;
  EFormItemKeyBoard? keyBoard;
  Function(dynamic value)? onTap;
  Function(dynamic value)? onCondition;
  Function? onFind;
  Function(dynamic value, Map<String, TextEditingController> listController)? onChange;
  Function(dynamic value, Map<String, TextEditingController> listController)? onValidator;
  String? icon;
  Widget? suffix;
  List<MOption>? items;
  Function(dynamic json)? format;
  Function(Map<String, dynamic> value, int page, int size, Map<String, dynamic> sort)? api;
  Function(dynamic content, int index)? itemSelect;
  bool? showSearch;
  Function? selectLabel;
  Function? selectValue;
  int minQuantity;
  int maxQuantity;
  String? prefix;
  Widget? child;
  DataType? dataType;
  bool stackedLabel;
  bool bold;
  SelectDateType selectDateType;
  UploadType uploadType;
  int? maxCountUpload;
  FormatNumberType formatNumberType;
  Color? color;
  String? description;
  DateRangePickerSelectionMode mode;
  bool showTime;

  factory MFormItem.fromJson(Map<String, dynamic> json) => MFormItem(
        name: json["name"] ?? '',
        type: json["type"] ?? '',
        label: json["label"] ?? '',
        subtitle: json["subtitle"],
        hintText: json["hintText"],
        value: json["value"] ?? '',
        code: json["code"] ?? '',
        maxLines: json["maxLines"] ?? 1,
        maxLength: json["maxLength"],
        minLength: json["minLength"],
        required: json["required"] ?? true,
        show: json["show"] ?? true,
        enabled: json["enabled"] ?? true,
        password: json["password"] ?? false,
        showClose: json["showClose"] ?? false,
        keyBoard: json["keyBoard"],
        bold: json["bold"] ?? false,
        onTap: json["onTap"],
        onCondition: json["onCondition"],
        onFind: json["onFind"],
        onChange: json["onChange"],
        onValidator: json["onValidator"],
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
        prefix: json["prefix"],
        child: json["child"],
        dataType: json["dataType"] ?? DataType.normal,
        selectDateType: json["selectDateType"] ?? SelectDateType.full,
        uploadType: json["uploadType"] ?? UploadType.multiple,
        formatNumberType: json["formatNumberType"] ?? FormatNumberType.inputFormatters,
        maxCountUpload: json["maxCountUpload"],
        color: json["color"],
        stackedLabel: json["stackedLabel"] ?? false,
        description: json["description"] ?? '',
        mode: json["mode"] ?? '',
        showTime: json["showTime"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "label": label,
        "hintText": hintText,
        "subtitle": subtitle,
        "value": value,
        "code": code,
        "maxLines": maxLines,
        "maxLength": maxLength,
        "minLength": minLength,
        "required": required,
        "show": show,
        "enabled": enabled,
        "bold": bold,
        "password": password,
        "showClose": showClose,
        "keyBoard": keyBoard,
        "onTap": onTap,
        "onCondition": onCondition,
        "onFind": onFind,
        "onChange": onChange,
        "onValidator": onValidator,
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
        "prefix": prefix,
        "child": child,
        "dataType": dataType,
        "selectDateType": selectDateType,
        "uploadType": uploadType,
        "stackedLabel": stackedLabel,
        "maxCountUpload": maxCountUpload,
        "formatNumberType": formatNumberType,
        "color": color,
        "description": description,
        "mode": mode,
        "showTime": showTime,
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

// enum Type {select, selectMultiple, date, time, upload, defaults}

enum DataType { phone, status, separation, normal, column, button, copy, image }

enum SelectDateType { before, after, full }

enum UploadType { single, multiple }

enum FormatNumberType { normal, inputFormatters }
