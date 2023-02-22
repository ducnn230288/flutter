class ModelFormItem {
  ModelFormItem({
    this.name = '',
    this.type = '',
    this.label = '',
    this.value = '',
    this.maxLines = 1,
    this.required = true,
    this.show = true,
    this.enabled = true,
    this.password = false,
    this.number = false,
    this.email = false,
    this.placeholder = true,
    this.onTap,
    this.onFind,
    this.onChange,
    this.icon,
    this.suffix,
    this.items,
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
  bool email;
  bool placeholder;
  Function? onTap;
  Function? onFind;
  Function? onChange;
  String? icon;
  String? suffix;
  List<ModelOption>? items;

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
        email: json["email"] ?? false,
        placeholder: json["placeholder"] ?? true,
        onTap: json["onTap"] ?? null,
        onFind: json["onFind"] ?? null,
        onChange: json["onChange"] ?? null,
        icon: json["icon"] ?? null,
        suffix: json["suffix"] ?? null,
        items: json["items"] != null ? List<ModelOption>.from(json["items"].map((x) => ModelOption.fromJson(x))) : null,
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
        "email": email,
        "placeholder": placeholder,
        "onTap": onTap,
        "onFind": onFind,
        "onChange": onChange,
        "icon": icon,
        "suffix": suffix,
        "items": items != null ? List<dynamic>.from(items!.map((x) => x.toJson())) : null,
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
