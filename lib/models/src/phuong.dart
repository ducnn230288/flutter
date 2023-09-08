class MPhuong {
  MPhuong({
    num? communeCode,
    String? communeName,
    num? districtCode,
    String? communeFullName,
  }) {
    _communeCode = communeCode;
    _communeName = communeName;
    _districtCode = districtCode;
    _communeFullName = communeFullName;
  }

  MPhuong.fromJson(dynamic json) {
    _communeCode = json['communeCode'];
    _communeName = json['communeName'];
    _districtCode = json['districtCode'];
    _communeFullName = json['communeFullName'];
  }

  num? _communeCode;
  String? _communeName;
  num? _districtCode;
  String? _communeFullName;

  MPhuong copyWith({
    num? communeCode,
    String? communeName,
    num? districtCode,
    String? communeFullName,
  }) =>
      MPhuong(
        communeCode: communeCode ?? _communeCode,
        communeName: communeName ?? _communeName,
        districtCode: districtCode ?? _districtCode,
        communeFullName: communeFullName ?? _communeFullName,
      );

  num? get communeCode => _communeCode;

  String get communeName => _communeName ?? '';

  num? get districtCode => _districtCode;

  String? get communeFullName => _communeFullName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['communeCode'] = _communeCode;
    map['communeName'] = _communeName;
    map['districtCode'] = _districtCode;
    map['communeFullName'] = _communeFullName;
    return map;
  }
}
