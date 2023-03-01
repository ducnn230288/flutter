class ModelData {
  ModelData(
      {this.page = 1,
      this.totalPages = 1,
      this.size = 20,
      this.numberOfElements = 1,
      this.totalElements = 1,
      required this.content});

  int page;
  int totalPages;
  int size;
  int numberOfElements;
  int totalElements;
  List content;

  factory ModelData.fromJson(Map<String, dynamic> json, format) {
    List content = json["content"] ?? [];

    List listNew = [];
    for (var i = 0; i < content.length; i++) {
      listNew.add(format(content[i]));
    }
    return ModelData(
      page: json["page"] ?? 1,
      totalPages: json["totalPages"] ?? 1,
      size: json["size"] ?? 1,
      numberOfElements: json["numberOfElements"] ?? 20,
      totalElements: json["totalElements"] ?? 1,
      content: listNew,
    );
  }

  Map<String, dynamic> toJson() => {
        "page": page,
        "totalPages": totalPages,
        "size": size,
        "numberOfElements": numberOfElements,
        "totalElements": totalElements,
        "data": content,
      };
}
