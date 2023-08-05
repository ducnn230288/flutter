class MTinh {
  MTinh({
    num? maTinh,
    String? tenTinh,
    num? totalDistrictShipDelay,
    num? totalDistrictShipStop,
  }) {
    _maTinh = maTinh;
    _tenTinh = tenTinh;
    _totalDistrictShipDelay = totalDistrictShipDelay;
    _totalDistrictShipStop = totalDistrictShipStop;
  }

  MTinh.fromJson(dynamic json) {
    _maTinh = json['maTinh'];
    _tenTinh = json['tenTinh'];
    _totalDistrictShipDelay = json['totalDistrictShipDelay'];
    _totalDistrictShipStop = json['totalDistrictShipStop'];
  }
  num? _maTinh;
  String? _tenTinh;
  num? _totalDistrictShipDelay;
  num? _totalDistrictShipStop;
  MTinh copyWith({
    num? maTinh,
    String? tenTinh,
    num? totalDistrictShipDelay,
    num? totalDistrictShipStop,
  }) =>
      MTinh(
        maTinh: maTinh ?? _maTinh,
        tenTinh: tenTinh ?? _tenTinh,
        totalDistrictShipDelay: totalDistrictShipDelay ?? _totalDistrictShipDelay,
        totalDistrictShipStop: totalDistrictShipStop ?? _totalDistrictShipStop,
      );
  num get maTinh => _maTinh ?? 0;
  String get tenTinh => _tenTinh ?? '';
  num? get totalDistrictShipDelay => _totalDistrictShipDelay;
  num? get totalDistrictShipStop => _totalDistrictShipStop;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['maTinh'] = _maTinh;
    map['tenTinh'] = _tenTinh;
    map['totalDistrictShipDelay'] = _totalDistrictShipDelay;
    map['totalDistrictShipStop'] = _totalDistrictShipStop;
    return map;
  }
}
