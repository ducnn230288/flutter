import 'dart:convert';

import 'package:http/http.dart';

import '/models/index.dart';
import 'base_http.dart';

class SAddress {
  late String endpoint;
  late Map<String, String> headers;
  late Future<MApi?> Function({required Response result}) checkAuth;

  SAddress(this.endpoint, this.headers, this.checkAuth);

  Future<MApi?> getTinh({Map<String, dynamic> filter = const {}}) async => checkAuth(
      result: await BaseHttp.get(
        url: '$endpoint/tinh',
        headers: headers,
        queryParameters: {
          'filter': jsonEncode(filter),
        },
      ));

  Future<MApi?> getHuyen({Map<String, dynamic> filter = const {}}) async => checkAuth(
      result: await BaseHttp.get(
        url: '$endpoint/huyen',
        headers: headers,
        queryParameters: {
          'filter': jsonEncode(filter),
        },
      ));

  Future<MApi?> getPhuong({Map<String, dynamic> filter = const {}}) async => checkAuth(
      result: await BaseHttp.get(
        url: '$endpoint/phuong',
        headers: headers,
        queryParameters: {
          'filter': jsonEncode(filter),
        },
      ));
}
