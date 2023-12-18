class DrawerData {
  String? parentId;
  String? urlRewrite;
  String? iconClass;
  List<SubChild>? subChild;
  List<String>? roleList;
  String? subUrl;
  int? type;
  String? id;
  String? code;
  String? name;
  String? idPath;
  String? path;
  int? level;
  int? order;
  bool? status;
  bool? isExpansion;

  DrawerData(
      {this.parentId,
      this.urlRewrite,
      this.iconClass,
      this.subChild,
      this.roleList,
      this.subUrl,
      this.type,
      this.id,
      this.code,
      this.name,
      this.idPath,
      this.path,
      this.level,
      this.order,
      this.status,
      this.isExpansion});

  DrawerData.fromJson(dynamic json) {
    parentId = json['parentId'] ?? '';
    urlRewrite = json['urlRewrite'] ?? '';
    iconClass = json['iconClass'] ?? '';
    if (json['subChild'] != null) {
      subChild = <SubChild>[];
      json['subChild'].forEach((v) {
        subChild!.add(SubChild.fromJson(v));
      });
    } else {
      subChild = [];
    }
    roleList = json['subChild'] != null ? json['roleList']?.cast<String>() : [];
    subUrl = json['subUrl'] ?? '';
    type = json['type'] ?? 0;
    id = json['id'] ?? '';
    code = json['code'] ?? '';
    name = json['name'] ?? '';
    idPath = json['idPath'] ?? '';
    path = json['path'] ?? '';
    level = json['level'];
    order = json['order'];
    status = json['status'] ?? false;
    isExpansion = json['isExpansion'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['parentId'] = parentId;
    data['urlRewrite'] = urlRewrite;
    data['iconClass'] = iconClass;
    if (subChild != null) {
      data['subChild'] = subChild!.map((v) => v.toJson()).toList();
    } else {
      data['subChild'] = [];
    }
    data['roleList'] = roleList;
    data['subUrl'] = subUrl;
    data['type'] = type;
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['idPath'] = idPath;
    data['path'] = path;
    data['level'] = level;
    data['order'] = order;
    data['status'] = status;
    data['isExpansion'] = isExpansion;
    return data;
  }
}

class SubChild {
  String? parentId;
  String? urlRewrite;
  String? iconClass;
  List<void>? subChild;
  dynamic roleList;
  dynamic subUrl;
  int? type;
  String? id;
  String? code;
  String? name;
  dynamic idPath;
  dynamic path;
  int? level;
  dynamic order;
  dynamic status;

  SubChild(
      {this.parentId,
      this.urlRewrite,
      this.iconClass,
      this.subChild,
      this.roleList,
      this.subUrl,
      this.type,
      this.id,
      this.code,
      this.name,
      this.idPath,
      this.path,
      this.level,
      this.order,
      this.status});

  SubChild.fromJson(Map<String, dynamic> json) {
    parentId = json['parentId'] ?? '';
    urlRewrite = json['urlRewrite'] ?? '';
    iconClass = json['iconClass'] ?? '';
    if (json['subChild'] != null) {
      subChild = <Null>[];
    }
    roleList = json['roleList'];
    subUrl = json['subUrl'] ?? '';
    type = json['type'] ?? 0;
    id = json['id'] ?? '';
    code = json['code'] ?? '';
    name = json['name'] ?? '';
    idPath = json['idPath'] ?? '';
    path = json['path'] ?? '';
    level = json['level'] ?? 0;
    order = json['order'] ?? '';
    status = json['status'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['parentId'] = parentId;
    data['urlRewrite'] = urlRewrite;
    data['iconClass'] = iconClass;
    if (subChild != null) {
      data['subChild'] = subChild;
    }
    data['roleList'] = roleList;
    data['subUrl'] = subUrl;
    data['type'] = type;
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['idPath'] = idPath;
    data['path'] = path;
    data['level'] = level;
    data['order'] = order;
    data['status'] = status;
    return data;
  }
}
