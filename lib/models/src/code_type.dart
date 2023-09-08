class MCodeType {
  MCodeType({
    String? title,
    String? code,
  }) {
    _title = title;
    _code = code;
  }

  MCodeType.fromJson(dynamic json) {
    _title = json['title'];
    _code = json['code'];
  }

  String? _title;
  String? _code;

  MCodeType copyWith({
    String? title,
    String? code,
  }) =>
      MCodeType(
        title: title ?? _title,
        code: code ?? _code,
      );

  String get title => _title ?? '';

  String get code => _code ?? '';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['code'] = _code;
    return map;
  }
}
