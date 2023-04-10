import 'dart:convert';

import 'package:http/http.dart';

import '/models/index.dart';
import 'base_http.dart';

class SUser {
  late String endpoint;
  late Map<String, String> headers;
  late Future<MApi?> Function({required Response result}) checkAuth;

  SUser(this.endpoint, this.headers, this.checkAuth);

  Future<MApi?> get({Map<String, dynamic> filter = const {}, int page = 1, int size = 10}) async => checkAuth(
          result: await BaseHttp.get(
        url: '$endpoint/idm/users',
        headers: headers,
        queryParameters: {
          'filter': jsonEncode(filter),
          'page': page.toString(),
          'size': size.toString(),
        },
      ));
}
