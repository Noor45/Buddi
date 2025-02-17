// ignore_for_file: non_constant_identifier_names

import 'dart:convert' as json;
import 'package:buddi/utils/keys.dart';
import 'package:http/http.dart' as http;

class NetworkUtil {
  static final BASE_URL = "https://fcm.googleapis.com/fcm/send";

  static NetworkUtil _instance = new NetworkUtil.internal();

  NetworkUtil.internal();
  factory NetworkUtil() => _instance;
  final json.JsonDecoder _decoder = json.JsonDecoder();
  Future<dynamic> post({headers, body, encoding, String? baseURL}) {
    var url = Uri.parse(BASE_URL);
    return http
        .post(url,
            body: body,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'key=' + Keys.SERVER_KEY,
            },
            encoding: encoding)
        .then((http.Response response) {
      String res = response.body;
      return _decoder.convert(res);
    });
  }
}
