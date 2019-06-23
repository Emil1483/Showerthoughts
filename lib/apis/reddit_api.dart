import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:io';

import '../models/thought.dart';

class Api {
  final HttpClient _httpClient = HttpClient();
  int currentLen = 0;
  String _lastPost = "t3_bpql00";

  Future<List<Thougth>> nextThougths() async {
    try {
      final Uri uri = Uri.parse(
          "https://www.reddit.com/r/Showerthoughts/best.json?limit=10&after=$_lastPost");
      final httpRequest = await _httpClient.getUrl(uri);
      final httpResponse = await httpRequest.close();
      if (httpResponse.statusCode != HttpStatus.ok) return null;

      final responseBody = await httpResponse.transform(utf8.decoder).join();
      final jsonResponse = json.decode(responseBody);
      final int len = jsonResponse["data"]["children"].length;
      currentLen += len;
      _lastPost = jsonResponse["data"]["children"][len - 1]["data"]["name"];
      List<Thougth> result = [];
      for (int i = 0; i < len; i++) {
        result.add(
          Thougth(
            thougth: jsonResponse["data"]["children"][i]["data"]["title"],
            author: jsonResponse["data"]["children"][i]["data"]["author"],
          ),
        );
      }
      return result;
    } on Exception catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
