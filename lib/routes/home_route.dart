import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:showerthoughts/routes/about_route.dart';

import '../models/thought.dart';
import '../ui_elements/thought_tile.dart';
import '../apis/reddit_api.dart';
import '../ui_elements/error.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> with WidgetsBindingObserver {
  final Duration _tryDelay = Duration(milliseconds: 200);
  final int _triesBeforeTimeout = 50;

  final Api _redditApi = Api();

  bool _hasError = false;
  List<List<Thougth>> _thoughts = [];

  int _wantedLen = 0;
  bool _working = false;

  List<Thougth> _saved = [];
  bool _showSaved = false;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //_loadSaved();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _saveData();
    }
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
      setState(() {
        _saved = Thougth.listFromJson(data);
      });
    } catch (e) {
      file.writeAsString(json.encode({}));
    }
  }

  void _saveData() async {
    final File file = await _getFile();
    Map<String, dynamic> data = {};
    for (Thougth thougth in _saved) {
      data.addAll(thougth.toJson());
    }
    await file.writeAsString(json.encode(data));
  }

  Future<List<Thougth>> _getThoughts(int index) async {
    if (index < _thoughts.length) return _thoughts[index];
    _getMore(index + 1);
    bool shouldCount = index == _thoughts.length;
    int count = 0;
    while (index >= _thoughts.length) {
      await Future.delayed(_tryDelay);
      if (shouldCount) {
        count++;
        if (count >= _triesBeforeTimeout) {
          _callError();
          return null;
        }
      }
    }

    return _thoughts[index];
  }

  void _getMore(int newLen) async {
    if (newLen > _wantedLen) _wantedLen = newLen;
    if (_working) return;
    _working = true;
    while (_thoughts.length < _wantedLen) {
      final List<Thougth> moreThougths = await _redditApi.nextThougths();
      if (moreThougths == null) {
        _callError();
        return;
      }
      _thoughts.add(moreThougths);
      if (_containesDuplicates())
        print("WARNING: _thoughts containes duplicates");
    }
    _working = false;
  }

  void _callError() {
    _working = false;
    setState(() {
      _hasError = true;
    });
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

  Future _onRefresh() async {
    final bool shouldTryAgain = await _redditApi.test();
    if (!shouldTryAgain) return;
    setState(() {
      _hasError = false;
    });
  }

  Widget _buildSavedListTile() {
    return _showSaved
        ? ListTile(
            leading: Icon(Icons.lightbulb_outline),
            title: Text(
              "Thoughts",
              style: Theme.of(context).textTheme.subhead,
            ),
            onTap: () {
              setState(() {
                _showSaved = false;
              });
              Navigator.of(context).pop();
            },
          )
        : ListTile(
            leading: Icon(Icons.favorite_border),
            title: Text(
              "Saved",
              style: Theme.of(context).textTheme.subhead,
            ),
            onTap: () {
              setState(() {
                _showSaved = true;
              });
              Navigator.of(context).pop();
            },
          );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Material(
        color: Theme.of(context).cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 16.0),
            Image.asset(
              "assets/shower.png",
              scale: 4,
            ),
            _buildSavedListTile(),
            ListTile(
              leading: Icon(Icons.mail),
              title: Text(
                "About me",
                style: Theme.of(context).textTheme.subhead,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AboutRoute()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  SliverChildDelegate _buildSliverDelegate(BuildContext context) {
    return !_showSaved
        ? SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return FutureBuilder(
                future: _getThoughts(index),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return ListView(
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      primary: false,
                      children: List.generate(Api.batchSize, (int index) {
                        return ThoughtTile(
                          thought: null,
                        );
                      }),
                    );
                  } else {
                    final List<Thougth> data = snapshot.data;
                    return ListView(
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      primary: false,
                      children: data.map(
                        (Thougth thought) {
                          return ThoughtTile(
                            thought: thought,
                          );
                        },
                      ).toList(),
                    );
                  }
                },
              );
            },
          )
        : SliverChildListDelegate(
            _saved.map((Thougth thought) {
              return ThoughtTile(thought: thought);
            }).toList(),
          );
  }

  Widget _buildAfterAppBar(BuildContext context) {
    return _hasError
        ? SliverFillRemaining(
            child: Error(
              color: Theme.of(context).accentColor,
            ),
          )
        : SliverList(
            delegate: _buildSliverDelegate(context),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        notificationPredicate: (_) => _hasError,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: true,
              flexibleSpace: Image.asset(
                "assets/shower.png",
                color: _hasError
                    ? Theme.of(context).accentColor
                    : Theme.of(context).indicatorColor,
              ),
            ),
            _buildAfterAppBar(context),
          ],
        ),
      ),
    );
  }
}
