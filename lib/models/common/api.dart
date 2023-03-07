class ModelApi {
  ModelApi({
    this.code = 400,
    this.isSuccess = false,
    this.message = '',
    this.totalTime = 0,
    this.errorDetail,
    required this.data,
  });

  int code;
  bool isSuccess;
  String message;
  int totalTime;
  String? errorDetail;
  dynamic data;

  factory ModelApi.fromJson(Map<String, dynamic> json) => ModelApi(
        code: json["code"] ?? 400,
        isSuccess: json["isSuccess"] ?? false,
        message: json["message"] ?? '',
        totalTime: json["totalTime"] ?? 0,
        errorDetail: json["errorDetail"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "isSuccess": isSuccess,
        "message": message,
        "totalTime": totalTime,
        "errorDetail": errorDetail,
        "data": data,
      };
}
