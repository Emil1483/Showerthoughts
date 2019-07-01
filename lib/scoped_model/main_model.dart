import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_admob/firebase_admob.dart';

import '../models/thought.dart';
import '../apis/reddit_api.dart';
import '../advert_ids.dart';

class MainModel extends Model {
  final Api _redditApi = Api();
  final int _numBeforeInterstitial = 5;

  List<List<Thougth>> _thoughts = [];
  List<Thougth> _saved = [];

  int _wantedLen = 0;
  bool _working = false;

  bool _hasError = false;

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  MobileAdTargetingInfo _targetingInfo;

  MainModel() {
    _loadSaved();
    _initTargetingInfo();
    _initAdBanner();
    _initInterstitialAd();
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

  void _initTargetingInfo() {
    _targetingInfo = MobileAdTargetingInfo(
      keywords: [
        "quotes",
        "reading",
        "books",
        "thinking",
      ],
      childDirected: false,
      designedForFamilies: false,
      testDevices: <String>["3C2BACC3B6177D291D421EFA6B1DBCE3"],
    );
  }

  void _initAdBanner() async {
    _bannerAd = BannerAd(
      adUnitId: AdvertIds.bannerId,
      size: AdSize.smartBanner,
      targetingInfo: _targetingInfo,
    );
    await _bannerAd.load();
    await _bannerAd.show(anchorType: AnchorType.bottom);
  }

  void _initInterstitialAd() {
    _interstitialAd = InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId, //AdvertIds.interstitialId,
        targetingInfo: _targetingInfo,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.closed) {
            _initInterstitialAd();
          }
        });
  }

  int _interstitialCount = 0;
  void showInterstitialAdSometimes() async {
    _interstitialCount++;
    if (_interstitialCount < _numBeforeInterstitial) return;
    _interstitialCount = 0;
    await _interstitialAd.load();
    await _interstitialAd.show();
  }

  void disposeAds() {
    _bannerAd.dispose();
    _interstitialAd.dispose();
  }

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
