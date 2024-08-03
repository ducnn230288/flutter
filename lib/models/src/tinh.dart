class MTinh {
  MTinh({
    num? provinceCode,
    String? provinceName,
    num? totalDistrictShipDelay,
    num? totalDistrictShipStop,
  }) {
    _provinceCode = provinceCode;
    _provinceName = provinceName;
    _totalDistrictShipDelay = totalDistrictShipDelay;
    _totalDistrictShipStop = totalDistrictShipStop;
  }

  MTinh.fromJson(dynamic json) {
    _provinceCode = json['provinceCode'];
    _provinceName = json['provinceName'];
    _totalDistrictShipDelay = json['totalDistrictShipDelay'];
    _totalDistrictShipStop = json['totalDistrictShipStop'];
  }

  num? _provinceCode;
  String? _provinceName;
  num? _totalDistrictShipDelay;
  num? _totalDistrictShipStop;

  MTinh copyWith({
    num? provinceCode,
    String? provinceName,
    num? totalDistrictShipDelay,
    num? totalDistrictShipStop,
  }) =>
      MTinh(
        provinceCode: provinceCode ?? _provinceCode,
        provinceName: provinceName ?? _provinceName,
        totalDistrictShipDelay: totalDistrictShipDelay ?? _totalDistrictShipDelay,
        totalDistrictShipStop: totalDistrictShipStop ?? _totalDistrictShipStop,
      );

  num get provinceCode => _provinceCode ?? 0;

  String get provinceName => _provinceName ?? '';

  num? get totalDistrictShipDelay => _totalDistrictShipDelay;

  num? get totalDistrictShipStop => _totalDistrictShipStop;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['provinceCode'] = _provinceCode;
    map['provinceName'] = _provinceName;
    map['totalDistrictShipDelay'] = _totalDistrictShipDelay;
    map['totalDistrictShipStop'] = _totalDistrictShipStop;
    return map;
  }
}
