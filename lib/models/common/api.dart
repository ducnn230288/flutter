class MApi {
  MApi({
    num? code,
    String? message,
    num? totalTime,
    bool? isSuccess,
    dynamic data,
    String? errorDetail,
  }) {
    _code = code;
    _message = message;
    _totalTime = totalTime;
    _isSuccess = isSuccess;
    _data = data;
    _errorDetail = errorDetail;
  }

  MApi.fromJson(dynamic json) {
    _code = json['code'];
    _message = json['message'];
    _totalTime = json['totalTime'];
    _isSuccess = json['isSuccess'];
    _data = json['data'];
    _errorDetail = json['errorDetail'];
  }
  num? _code;
  String? _message;
  num? _totalTime;
  bool? _isSuccess;
  dynamic _data;
  String? _errorDetail;
  MApi copyWith({
    num? code,
    String? message,
    num? totalTime,
    bool? isSuccess,
    dynamic data,
    String? errorDetail,
  }) =>
      MApi(
        code: code ?? _code,
        message: message ?? _message,
        totalTime: totalTime ?? _totalTime,
        isSuccess: isSuccess ?? _isSuccess,
        data: data ?? _data,
        errorDetail: errorDetail ?? _errorDetail,
      );
  num? get code => _code;
  String? get message => _message;
  num? get totalTime => _totalTime;
  bool get isSuccess => _isSuccess ?? false;
  dynamic get data => _data;
  String? get errorDetail => _errorDetail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['message'] = _message;
    map['totalTime'] = _totalTime;
    map['isSuccess'] = _isSuccess;
    map['data'] = _data;
    map['errorDetail'] = _errorDetail;
    return map;
  }
}
