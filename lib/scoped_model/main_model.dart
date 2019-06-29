import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

import '../models/thought.dart';
import '../apis/reddit_api.dart';

class MainModel extends Model {
  List<List<Thougth>> _thoughts = [];
  List<Thougth> _saved = [];

  int _wantedLen = 0;
  bool _working = false;

  final Api _redditApi = Api();

  bool _hasError = false;

  MainModel() {
    _loadSaved();
  }

  List<Thougth> get thoughts {
    List<Thougth> result = [];
    for (List<Thougth> thoughts in _thoughts) {
      for (Thougth thougth in thoughts) {
        result.add(thougth);
      }
    }
    return result;
  }

  List<Thougth> get saved => List.from(_saved);

  bool get hasError => _hasError;

  void addToSaved(Thougth newThought) {
    if (_saved.contains(newThought)) return;
    _saved.add(newThought);
  }

  void removeFromSaved(Thougth newThought) {
    if (!_saved.contains(newThought)) return;
    _saved.remove(newThought);
  }

  void getMore(int newLen) async {
    if (newLen > _wantedLen) _wantedLen = newLen;
    if (_working) return;
    _working = true;
    while (_thoughts.length < _wantedLen) {
      final List<Thougth> moreThougths = await _redditApi.nextThougths();
      if (moreThougths == null) {
        callError();
        return;
      }
      _thoughts.add(moreThougths);
      if (_containesDuplicates())
        print("WARNING: _thoughts containes duplicates");
    }
    _working = false;
  }

  void callError() {
    _working = false;
    _hasError = true;
    notifyListeners();
  }

  bool _containesDuplicates() {
    List<Thougth> allThoughts = [];
    for (List<Thougth> thoughts in _thoughts) {
      for (Thougth thought in thoughts) {
        allThoughts.add(thought);
      }
    }
    for (int i = 0; i < allThoughts.length - 1; i++) {
      Thougth thought1 = allThoughts[i];
      for (int j = i + 1; j < allThoughts.length; j++) {
        Thougth thought2 = allThoughts[j];
        if (thought1 == thought2) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> testInternet() async {
    if (await _redditApi.test()) {
      _hasError = false;
      notifyListeners();
    }
  }

  Future<File> _getFile() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/saved.json");
  }

  void _loadSaved() async {
    File file = await _getFile();
    try {
      String jsonString = await file.readAsString();
      Map<String, dynamic> data = json.decode(jsonString);
      _saved = Thougth.listFromJson(data);
    } catch (e) {
      file.writeAsString(json.encode({}));
    }
  }

  void saveData() async {
    final File file = await _getFile();
    Map<String, dynamic> data = {};
    for (Thougth thougth in _saved) {
      data.addAll(thougth.toJson());
    }
    await file.writeAsString(json.encode(data));
  }

  static MainModel of(BuildContext context) {
    return ScopedModel.of<MainModel>(context);
  }
}
