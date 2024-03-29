class MData<T> {
  MData({
    num? page,
    num? totalPages,
    num? size,
    num? numberOfElements,
    num? totalElements,
    List<T>? content,
    T? data,
  }) {
    _page = page;
    _totalPages = totalPages;
    _size = size;
    _numberOfElements = numberOfElements;
    _totalElements = totalElements;
    _content = content;
  }

  MData.fromJson(dynamic json, dynamic format) {
    _page = json is List || !json.containsKey('page') ? 1 : json['page'];
    _totalPages = json is List || !json.containsKey('totalPages')? 1 : json['totalPages'];
    _size = json is List || !json.containsKey('size') ? 1 : json['size'];
    _numberOfElements = json is List || !json.containsKey('numberOfElements') ? json.length : json['numberOfElements'];
    _totalElements = json is List || !json.containsKey('totalElements') ? json.length : json['totalElements'];
    dynamic data = json is List || (!json.containsKey('content') && !json.containsKey('data')) ? json : json.containsKey('content') ? json['content'] : json['data'];

    if (format != null) {
      if (data != null && data is List) {
        _content = [];
        for (var v in data) {
          _content?.add(v.runtimeType == T ? v : format(v));
        }
      } else {
        _data = format(data);
      }
    } else {
      _content = data;
    }
  }

  num? _page;
  num? _totalPages;
  num? _size;
  num? _numberOfElements;
  num? _totalElements;
  List<T>? _content;
  T? _data;

  MData<T> copyWith({
    num? page,
    num? totalPages,
    num? size,
    num? numberOfElements,
    num? totalElements,
    List<T>? content,
    dynamic data,
  }) =>
      MData<T>(
        page: page ?? _page,
        totalPages: totalPages ?? _totalPages,
        size: size ?? _size,
        numberOfElements: numberOfElements ?? _numberOfElements,
        totalElements: totalElements ?? _totalElements,
        content: content ?? _content,
        data: data ?? _data,
      );

  num? get page => _page;

  num? get totalPages => _totalPages;

  num? get size => _size;

  num? get numberOfElements => _numberOfElements;

  num? get totalElements => _totalElements;

  List<T> get content => _content ?? [];

  T? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page'] = _page;
    map['totalPages'] = _totalPages;
    map['size'] = _size;
    map['numberOfElements'] = _numberOfElements;
    map['totalElements'] = _totalElements;
    if (_content != null) {
      map['data'] = _content?.map((v) => v.toString()).toList();
    }
    return map;
  }
}
