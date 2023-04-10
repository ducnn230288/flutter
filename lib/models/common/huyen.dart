class MHuyen {
  MHuyen({
    num? districtCode,
    String? districtName,
    String? description,
    num? provinceCode,
    String? districtFullName,
  }) {
    _districtCode = districtCode;
    _districtName = districtName;
    _description = description;
    _provinceCode = provinceCode;
    _districtFullName = districtFullName;
  }

  MHuyen.fromJson(dynamic json) {
    _districtCode = json['districtCode'];
    _districtName = json['districtName'];
    _description = json['description'];
    _provinceCode = json['provinceCode'];
    _districtFullName = json['districtFullName'];
  }
  num? _districtCode;
  String? _districtName;
  String? _description;
  num? _provinceCode;
  String? _districtFullName;
  MHuyen copyWith({
    num? districtCode,
    String? districtName,
    String? description,
    num? provinceCode,
    String? districtFullName,
  }) =>
      MHuyen(
        districtCode: districtCode ?? _districtCode,
        districtName: districtName ?? _districtName,
        description: description ?? _description,
        provinceCode: provinceCode ?? _provinceCode,
        districtFullName: districtFullName ?? _districtFullName,
      );
  num get districtCode => _districtCode ?? 0;
  String get districtName => _districtName ?? '';
  String? get description => _description;
  num? get provinceCode => _provinceCode;
  String? get districtFullName => _districtFullName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['districtCode'] = _districtCode;
    map['districtName'] = _districtName;
    map['description'] = _description;
    map['provinceCode'] = _provinceCode;
    map['districtFullName'] = _districtFullName;
    return map;
  }
}
