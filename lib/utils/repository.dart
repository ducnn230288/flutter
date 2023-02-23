import 'dart:convert';

import '/models.dart';

class Repository {
  final Api _client = Api();

  Future<List<ModelOption>> getTrending({type = 'all', time = 'week'}) async {
    return (await _client.getTrending(type: type, time: time)).map((item) => ModelOption.fromJson(item)).toList();
  }
}

class Api {
  final endpoint = 'https://api.themoviedb.org/3';

  final apiKey = 'b8735916ebe69a988e7a757928558cf0';

  get http => null;

  Future<List<Map<String, dynamic>>> getTrending({type = 'all', time = 'week'}) async {
    var result = await http.get(Uri.parse('$endpoint/trending/$type/$time?api_key=$apiKey'));
    var body = jsonDecode(result.body);
    return List.castFrom<dynamic, Map<String, dynamic>>(body['results']);
  }
}
