import '/utils/src/environment.dart';

class MUpload {
  MUpload({
    String? id,
    String? description,
    String? entityType,
    String? docType,
    String? docTypeName,
    num? order,
    int? maxQuantity,
    int? minQuantity,
    String? fileUrl,
    String? file,
  }) {
    _id = id;
    _description = description;
    _entityType = entityType;
    _docType = docType;
    _docTypeName = docTypeName;
    _order = order;
    _maxQuantity = maxQuantity;
    _minQuantity = minQuantity;
    _fileUrl = fileUrl;
    _file = file;
  }

  MUpload.fromJson(dynamic json) {
    _id = json?['id'] ?? '';
    _description = json?['description'] ?? '';
    _entityType = json?['entityType'] ?? '';
    _docType = json?['docType'] ?? '';
    _docTypeName = json?['docTypeName'] ?? '';
    _order = json?['order'] ?? 0;
    _maxQuantity = json?['maxQuantity'] ?? 0;
    _minQuantity = json?['minQuantity'] ?? 0;
    _file = json?['fileUrl'] ?? json?['file'] ?? json['physicalPath'] ?? '';
    _fileUrl = ((_file as String).indexOf('http') < 0 ? Environment.fileUrl : '') + _file!;
  }
  String? _id;
  String? _description;
  String? _entityType;
  String? _docType;
  String? _docTypeName;
  num? _order;
  int? _maxQuantity;
  int? _minQuantity;
  String? _fileUrl;
  String? _file;
  MUpload copyWith({
    String? id,
    String? description,
    String? entityType,
    String? docType,
    String? docTypeName,
    num? order,
    int? maxQuantity,
    int? minQuantity,
    String? fileUrl,
    String? file,
  }) =>
      MUpload(
        id: id ?? _id,
        description: description ?? _description,
        entityType: entityType ?? _entityType,
        docType: docType ?? _docType,
        docTypeName: docTypeName ?? _docTypeName,
        order: order ?? _order,
        maxQuantity: maxQuantity ?? _maxQuantity,
        minQuantity: minQuantity ?? _minQuantity,
        fileUrl: fileUrl ?? _fileUrl,
        file: file ?? _file,
      );
  String get id => _id ?? '';
  String get description => _description ?? '';
  String get entityType => _entityType ?? '';
  String get docType => _docType ?? '';
  String get docTypeName => _docTypeName ?? '';
  num get order => _order ?? 0;
  int get maxQuantity => _maxQuantity ?? 1;
  int get minQuantity => _minQuantity ?? 1;
  String get fileUrl => _fileUrl ?? '';
  String get file => _file ?? '';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_id != '') map['id'] = _id;
    map['description'] = _description;
    map['entityType'] = _entityType;
    map['docType'] = _docType;
    map['docTypeName'] = _docTypeName;
    map['file'] = _file;
    return map;
  }
}
