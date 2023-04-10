class MData {
  MData({
    num? page,
    num? totalPages,
    num? size,
    num? numberOfElements,
    num? totalElements,
    List<dynamic>? content,
  }) {
    _page = page;
    _totalPages = totalPages;
    _size = size;
    _numberOfElements = numberOfElements;
    _totalElements = totalElements;
    _content = content;
  }

  MData.fromJson(dynamic json, dynamic format) {
    _page = json['page'];
    _totalPages = json['totalPages'];
    _size = json['size'];
    _numberOfElements = json['numberOfElements'];
    _totalElements = json['totalElements'];
    if (json['content'] != null) {
      if (format != null) {
        _content = [];
        json['content'].forEach((v) {
          _content?.add(format(v));
        });
      } else {
        _content = json['content'];
      }
    }
  }
  num? _page;
  num? _totalPages;
  num? _size;
  num? _numberOfElements;
  num? _totalElements;
  List<dynamic>? _content;
  MData copyWith({
    num? page,
    num? totalPages,
    num? size,
    num? numberOfElements,
    num? totalElements,
    List<dynamic>? content,
  }) =>
      MData(
        page: page ?? _page,
        totalPages: totalPages ?? _totalPages,
        size: size ?? _size,
        numberOfElements: numberOfElements ?? _numberOfElements,
        totalElements: totalElements ?? _totalElements,
        content: content ?? _content,
      );
  num? get page => _page;
  num? get totalPages => _totalPages;
  num? get size => _size;
  num? get numberOfElements => _numberOfElements;
  num? get totalElements => _totalElements;
  List<dynamic>? get content => _content;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page'] = _page;
    map['totalPages'] = _totalPages;
    map['size'] = _size;
    map['numberOfElements'] = _numberOfElements;
    map['totalElements'] = _totalElements;
    if (_content != null) {
      map['content'] = _content?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
