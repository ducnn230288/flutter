import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:http/http.dart';

import '/constants/index.dart';
import '/models/index.dart';
import 'base_http.dart';

class SUser {
  late String endpoint;
  late Map<String, String> headers;
  late Future<MApi?> Function({required Response result}) checkAuth;

  SUser(this.endpoint, this.headers, this.checkAuth);

  Future<MApi?> get({Map<String, dynamic> filter = const {}, int page = 1, int size = 20}) async => checkAuth(
          result: await BaseHttp.get(
        url: '$endpoint/idm/users',
        headers: headers,
        queryParameters: {
          'filter': jsonEncode({
            'isEmployee': GoRouter.of(rootNavigatorKey.currentState!.context).location.contains(CRoute.internalUser)
                ? true
                : false,
            ...filter
          }),
          'page': page.toString(),
          'size': size.toString(),
        },
      ));

  Future<MApi?> details({required String id}) async =>
      checkAuth(result: await BaseHttp.get(url: '$endpoint/idm/users/$id', headers: headers, queryParameters: {}));

  Future<MApi?> delete({required String id}) async =>
      checkAuth(result: await BaseHttp.delete(url: '$endpoint/idm/users/$id', headers: headers));

  Future<MApi?> action({required String id, required String action}) async =>
      checkAuth(result: await BaseHttp.put(url: '$endpoint/idm/users/$id/$action', headers: headers, body: {}));

  Future<MApi?> register({required body}) async =>
      checkAuth(result: await BaseHttp.post(url: '$endpoint/idm/users', headers: headers, body: body));

  Future<MApi?> edit({required String id, required body}) async =>
      checkAuth(result: await BaseHttp.put(url: '$endpoint/idm/users/$id', headers: headers, body: body));

  Future<MApi?> setPassword({required String id, required body}) async =>
      checkAuth(result: await BaseHttp.put(url: '$endpoint/idm/users/$id/password', headers: headers, body: body));
}
