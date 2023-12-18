import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '/constants/index.dart';
import '/cubit/index.dart';
import '/models/index.dart';
import '/service/index.dart';
import '/utils/index.dart';

class Api {
  SAuth get auth => SAuth(endpoint, headers, checkAuth);

  SDrawer get drawer => SDrawer(endpoint, headers, checkAuth);

  SAddress get address => SAddress(endpoint, headers, checkAuth);

  SUser get user => SUser(endpoint, headers, checkAuth);

  final String endpoint = Environment.apiUrl;
  final Map<String, String> headers = {'Content-Type': 'application/json'};

  Future<MApi?> checkAuth({required http.Response result, int? returnWithStatusCode}) async {
    if (result.body.isEmpty) {
      return null;
    }
    if (result.statusCode == 401) {
      rootNavigatorKey.currentState!.context.read<AuthC>().error();
      return null;
    }
    MApi response = MApi.fromJson(jsonDecode(result.body));
    if (returnWithStatusCode != null && response.code == returnWithStatusCode) {
      return response;
    }
    if (result.statusCode == 404) {
      return MApi(code: 404, message: response.message);
    }
    if (response.isSuccess == false && response.message != null) {
      Timer(const Duration(milliseconds: 50), () {
        UDialog().showError(text: response.message);
      });
      return null;
    }
    if (response.data is List) {
      return response.copyWith(data: {
        'page': 1,
        'totalPages': response.data.length,
        'size': response.data.length,
        'numberOfElements': response.data.length,
        'totalElements': response.data.length,
        'content': response.data
      });
    }
    return response;
  }

  Future setToken({required String token}) async {
    headers['Authorization'] = 'Bearer $token';
  }

  Future setLanguage({required String language}) async {
    headers['x-language'] = language;
  }

  Future<MUpload?> postUploadPhysicalBlob(
      {required XFile file, required String prefix, required Map<String, dynamic> obj}) async {
    http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse('$endpoint${Environment.uploadUrl}$prefix'));
    AppConsole.dump(request.url.queryParameters);
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = headers['Authorization'] ?? '';

    http.ByteStream stream = http.ByteStream(file.openRead());
    int length = await file.length();

    http.MultipartFile multipartFile = http.MultipartFile('file', stream, length, filename: file.name);
    request.files.add(multipartFile);
    var response = await request.send();
    final res = await http.Response.fromStream(response).timeout(const Duration(seconds: 20), onTimeout: () {
      return http.Response('Error', 408);
    });
    if (res.statusCode == 413) UDialog().showError(text: 'Dung lượng tệp được tải lên quá lớn');
    if (res.statusCode > 300) return null;
    dynamic data = {...jsonDecode(res.body)['data'], ...obj};
    return MUpload.fromJson(data);
  }

  Future<List<MUpload>> getAttachmentsTemplate({String entityType = 'post'}) async {
    http.Response result =
        await http.get(Uri.parse('$endpoint/upload/$entityType/attachment-templates'), headers: headers);
    List<MUpload> data = [];
    if (result.statusCode < 400) {
      List body = jsonDecode(result.body)['data'];
      for (int i = 0; i < body.length; i++) {
        data.add(MUpload.fromJson(body[i]));
      }
    }
    return data;
  }

  Future<dynamic> downloadFile({required http.Response response, String nameFile = 'test.png'}) async {
    File file;
    String filePath = '';
    String dir = '';

    final String fileName = response.headers['content-disposition'] != null
        ? response.headers['content-disposition']!.split(';')[1].split('=')[1].replaceAll(r'/\"/g', '')
        : nameFile;
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        dir = (await getExternalStorageDirectory())!.path;
        dir = '$dir/Download';
        dir = dir.replaceAll('Android/data/${Environment.appPackage}/files/', '');
        await Directory(dir).create(recursive: true);
      }
    } else if (Platform.isIOS) {
      dir = (await getApplicationDocumentsDirectory()).path;
    }
    filePath = '$dir/$fileName';
    file = File(filePath);
    file.writeAsBytesSync(response.bodyBytes);
    return fileName;
  }
}
