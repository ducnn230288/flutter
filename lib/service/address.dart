import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '/models/index.dart';

class SAddress {
  late String endpoint;
  late Map<String, String> headers;
  late Future<MApi?> Function({required Response result}) checkAuth;

  SAddress(this.endpoint, this.headers, this.checkAuth);

  Future<MApi?> getTinh() async => checkAuth(
      result: await http.get(Uri.parse('$endpoint/tinh'), headers: headers));

  Future<MApi?> getHuyen({Map<String, dynamic> filter = const {}}) async =>
      checkAuth(
          result: await http.get(
              Uri.parse('$endpoint/huyen').replace(queryParameters: {
                'filter': jsonEncode(filter),
              }),
              headers: headers));

  Future<MApi?> getPhuong({Map<String, dynamic> filter = const {}}) async =>
      checkAuth(
          result: await http.get(
              Uri.parse('$endpoint/phuong').replace(queryParameters: {
                'filter': jsonEncode(filter),
              }),
              headers: headers));
}
