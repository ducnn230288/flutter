import 'dart:convert';

import 'package:http/http.dart' as http;

import '/models/index.dart';

class Api {
  final endpoint = 'http://dev1.geneat.vn:7800/api/v1';

  final apiKey = 'b8735916ebe69a988e7a757928558cf0';

  final headers = {"Content-Type": "application/json"};

  Future<ModelApi?> checkAuth({required http.Response result, required logout}) async {
    if (result.statusCode < 400) {
      return ModelApi.fromJson(jsonDecode(result.body));
    } else if (result.statusCode == 401 && logout != null) {
      logout();
    }
    return null;
  }

  Future setToken({required String token}) async {
    headers['Authorization'] = 'Bearer $token';
  }

  // Future<List<Map<String, dynamic>>> login({required body}) async {
  //   var result = await http.post(Uri.parse('$endpoint/authentication/jwt/login'), body: jsonEncode(body));
  //   return List.castFrom<dynamic, Map<String, dynamic>>(jsonDecode(result.body)['results']);
  // }

  Future<ModelApi> login({required body}) async {
    http.Response result =
        await http.post(Uri.parse('$endpoint/authentication/jwt/login'), body: jsonEncode(body), headers: headers);
    return ModelApi.fromJson(jsonDecode(result.body));
  }

  Future<ModelApi> register({required body}) async {
    http.Response result =
        await http.post(Uri.parse('$endpoint/idm/users/register'), body: jsonEncode(body), headers: headers);
    return ModelApi.fromJson(jsonDecode(result.body));
  }

  Future<ModelApi> forgotPassword({required String email}) async {
    http.Response result =
        await http.put(Uri.parse('$endpoint/idm/users/forgot-password/$email'), body: jsonEncode({}), headers: headers);
    return ModelApi.fromJson(jsonDecode(result.body));
  }

  Future<ModelApi?> info({required String token}) async {
    headers['Authorization'] = 'Bearer $token';
    http.Response result =
        await http.post(Uri.parse('$endpoint/authentication/jwt/info'), body: jsonEncode({}), headers: headers);
    if (result.statusCode < 400) {
      return ModelApi.fromJson(jsonDecode(result.body));
    }
    return null;
  }

  Future<ModelApi?> getUser(
      {required logout, Map<String, dynamic> filter = const {}, int page = 1, int size = 20}) async {
    return checkAuth(
        result: await http.get(
            Uri.parse('$endpoint/idm/users').replace(queryParameters: {
              'filter': jsonEncode(filter),
              'page': page.toString(),
              'size': size.toString(),
            }),
            headers: headers),
        logout: logout);
  }
}
