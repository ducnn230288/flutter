import 'dart:convert';

import 'package:http/http.dart' as http;

import '/models/index.dart';

class Api {
  final endpoint = 'https://geneat.vn:8200/api/v1';

  final apiKey = 'b8735916ebe69a988e7a757928558cf0';

  final headers = {"Content-Type": "application/json"};

  // Future<List<Map<String, dynamic>>> login({required body}) async {
  //   var result = await http.post(Uri.parse('$endpoint/authentication/jwt/login'), body: jsonEncode(body));
  //   print('result');
  //   print(result);
  //   return List.castFrom<dynamic, Map<String, dynamic>>(jsonDecode(result.body)['results']);
  // }

  Future<ModelApi> login({required body}) async {
    dynamic result =
        await http.post(Uri.parse('$endpoint/authentication/jwt/login'), body: jsonEncode(body), headers: headers);
    return ModelApi.fromJson(jsonDecode(result.body));
  }
}
