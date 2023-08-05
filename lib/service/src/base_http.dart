import 'dart:convert';

import 'package:http/http.dart' as http;

import '/utils/index.dart';

enum EHttpType {
  post('post'),
  get('get'),
  delete('delete'),
  put('put');

  final String name;

  const EHttpType(this.name);
}

class BaseHttp {
  static int timeOut = 30;

  static Future<http.Response> _common({
    required String url,
    required Future<http.Response> fetch,
    required dynamic data,
    required dynamic queryParameters,
    required EHttpType type,
  }) async {
    try {
      http.Response result = await fetch;

      _dump(url, result, queryParameters: queryParameters, data: data, type: type.name.toUpperCase());

      // if (result.statusCode < 400) {
      //   return MApi.fromJson(jsonDecode(result.body));
      // }

      return result;
    } catch (ex) {
      _dumpError(url, ex.toString(), queryParameters: queryParameters, data: data, type: type.name.toUpperCase());
      rethrow;
    }
  }

  static Future<http.Response> post({
    required String url,
    required body,
    required Map<String, String> headers,
  }) async {
    final apiUri = Uri.parse(url);

    return await _common(
      url: url,
      fetch: http.post(
        apiUri,
        body: jsonEncode(body),
        headers: headers,
      ),
      data: body,
      queryParameters: null,
      type: EHttpType.post,
    ).timeout(Duration(seconds: timeOut), onTimeout: (){
      return http.Response('TIME_OUT', 504);
    });
  }

  static Future<http.Response> put({
    required String url,
    required body,
    required Map<String, String> headers,
  }) async {
    final apiUri = Uri.parse(url);

    return await _common(
      url: url,
      fetch: http.put(
        apiUri,
        body: jsonEncode(body),
        headers: headers,
      ),
      data: body,
      queryParameters: null,
      type: EHttpType.put,
    ).timeout(Duration(seconds: timeOut), onTimeout: (){
      return http.Response('TIME_OUT', 504);
    });
  }

  static Future<http.Response> get({
    required String url,
    required Map<String, String> headers,
    required Map<String, dynamic> queryParameters,
  }) async {
    Uri apiUri = Uri.parse(url);

    if (queryParameters.isNotEmpty) {
      apiUri = apiUri.replace(queryParameters: queryParameters);
    }

    return await _common(
      url: url,
      fetch: http.get(
        apiUri,
        headers: headers,
      ),
      data: null,
      queryParameters: queryParameters,
      type: EHttpType.get,
    ).timeout(Duration(seconds: timeOut), onTimeout: (){
      return http.Response('TIME_OUT', 504);
    });
  }

  static Future<http.Response> delete({
    required String url,
    required Map<String, String> headers,
  }) async {
    final apiUri = Uri.parse(url);

    return await _common(
      url: url,
      fetch: http.delete(
        apiUri,
        headers: headers,
      ),
      data: null,
      queryParameters: null,
      type: EHttpType.delete,
    ).timeout(Duration(seconds: timeOut), onTimeout: (){
      return http.Response('TIME_OUT', 504);
    });
  }

  static void _dump(String url, http.Response response, {queryParameters, data, type}) {
    AppConsole.dump('|***************************<<< START:$type >>>***************************');
    AppConsole.dump(url, name: "URL");
    if (queryParameters != null) {
      AppConsole.dump(queryParameters, name: "PARAM");
    }
    if (data != null) {
      AppConsole.dump(data, name: "DATA");
    }
    AppConsole.dump(response.body, name: 'RESPONSE');
    AppConsole.dump(response.statusCode, name: 'CODE');
    AppConsole.dump('***************************<<< END:$type >>>*****************************|');
  }

  static void _dumpError(String url, String error, {queryParameters, data, type}) {
    AppConsole.dump('|***************************<<< ERROR_START:$type >>>***************************');
    AppConsole.dump(url, name: "URL");
    if (queryParameters != null) {
      AppConsole.dump(queryParameters, name: "PARAM");
    }
    if (data != null) {
      AppConsole.dump(data, name: "DATA");
    }
    AppConsole.dump(error, name: 'ERROR_MESSAGE');
    AppConsole.dump('***************************<<< Error_END:$type >>>*****************************|');
  }
}
