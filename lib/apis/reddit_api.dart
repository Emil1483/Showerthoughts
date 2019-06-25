import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:io';

import '../models/thought.dart';

class Api {
  final HttpClient _httpClient = HttpClient();
  int currentLen = 0;
  String _lastPost = "t3_bpql00";

  static int batchSize = 10;

  int _workingID = 0;

  Future<bool> test() async {
    try {
      final Uri uri = Uri.parse(
          "https://www.reddit.com/r/Showerthoughts/best.json?limit=$batchSize&after=$_lastPost");

      final httpRequest = await _httpClient.getUrl(uri);
      final httpResponse = await httpRequest.close();

      if (httpResponse.statusCode != HttpStatus.ok) return false;

      final responseBody = await httpResponse.transform(utf8.decoder).join();
      final jsonResponse = json.decode(responseBody);

      final int len = jsonResponse["data"]["children"].length;
      String thought =
          jsonResponse["data"]["children"][len - 1]["data"]["title"];

      if (thought == null) return false;

      return true;
    } on Exception catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<List<Thougth>> nextThougths() async {
    _workingID++;
    int thisId = _workingID;

    try {
      final Uri uri = Uri.parse(
          "https://www.reddit.com/r/Showerthoughts/best.json?limit=$batchSize&after=$_lastPost");

      final httpRequest = await _httpClient.getUrl(uri);

      final httpResponse = await httpRequest.close();
      if (httpResponse.statusCode != HttpStatus.ok) {
        return null;
      }

      final responseBody = await httpResponse.transform(utf8.decoder).join();

      final jsonResponse = json.decode(responseBody);
      final int len = jsonResponse["data"]["children"].length;
      List<Thougth> result = [];
      for (int i = 0; i < len; i++) {
        result.add(
          Thougth(
            thougth: jsonResponse["data"]["children"][i]["data"]["title"],
            author: jsonResponse["data"]["children"][i]["data"]["author"],
          ),
        );
      }
      assert(thisId == _workingID);
      currentLen += len;
      _lastPost = jsonResponse["data"]["children"][len - 1]["data"]["name"];

      return result;
    } on Exception catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
