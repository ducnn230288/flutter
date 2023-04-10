import 'package:http/http.dart';

import '/models/index.dart';
import 'base_http.dart';

class SAuth {
  late String endpoint;
  late Map<String, String> headers;
  late Future<MApi?> Function({required Response result}) checkAuth;

  SAuth(this.endpoint, this.headers, this.checkAuth);

  Future<MApi?> login({required body}) async => checkAuth(
          result: await BaseHttp.post(
        url: '$endpoint/authentication/jwt/login',
        body: body,
        headers: headers,
      ));

  Future<MApi?> register({required body}) async => checkAuth(
          result: await BaseHttp.post(
        url: '$endpoint/idm/authentication/register',
        body: body,
        headers: headers,
      ));

  Future<MApi?> forgotPassword({required String email}) async => checkAuth(
      result: await BaseHttp.post(url: '$endpoint/idm/users/forgot-password/$email', body: {}, headers: headers));

  Future<MApi?> info({required String token}) async {
    headers['Authorization'] = 'Bearer $token';
    return checkAuth(
        result: await BaseHttp.post(
      url: '$endpoint/authentication/jwt/info',
      body: {},
      headers: headers,
    ));
  }
}
