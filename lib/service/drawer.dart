import 'package:http/http.dart';

import '/models/index.dart';
import 'base_http.dart';

class SDrawer {
  late String endpoint;
  late Map<String, String> headers;
  late Future<MApi?> Function({required Response result}) checkAuth;

  SDrawer(this.endpoint, this.headers, this.checkAuth);

  Future<MApi?> get() async => checkAuth(
          result: await BaseHttp.get(
        url: '$endpoint/bsd/navigations/user/mobile',
        headers: headers,
        queryParameters: {},
      ));
}
