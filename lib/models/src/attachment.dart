class MAttachment {
  MAttachment({
    String? id,
    String? docType,
    String? fileUrl,
    String? description,
  }) {
    _id = id;
    _docType = docType;
    _fileUrl = fileUrl;
    _description = description;
  }

  MAttachment.fromJson(dynamic json) {
    _id = json['id'];
    _docType = json['docType'];
    _fileUrl = json['fileUrl'];
    _description = json['description'];
  }
  String? _id;
  String? _docType;
  String? _fileUrl;
  String? _description;
  MAttachment copyWith({
    String? id,
    String? docType,
    String? fileUrl,
    String? description,
  }) =>
      MAttachment(
        id: id ?? _id,
        docType: docType ?? _docType,
        fileUrl: fileUrl ?? _fileUrl,
        description: description ?? _description,
      );
  String? get id => _id;
  String? get docType => _docType;
  String? get fileUrl => _fileUrl;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['docType'] = _docType;
    map['fileUrl'] = _fileUrl;
    map['description'] = _description;
    return map;
  }
}
