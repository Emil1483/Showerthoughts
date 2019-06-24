import 'package:flutter/material.dart';

import '../models/thought.dart';
import '../ui_elements/thought_tile.dart';
import '../apis/reddit_api.dart';
import '../ui_elements/error.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  final Api _redditApi = Api();

  bool _hasError = false;
  List<List<Thougth>> _thoughts = [];

  //TODO: Implement heart functionality

  Future<List<Thougth>> _getThoughts(int index) async {
    if (index < _thoughts.length) {
      return _thoughts[index];
    } else {
      final thoughts = await _redditApi.nextThougths();
      if (thoughts == null) {
        setState(() {
          _hasError = true;
        });
        return null;
      }
      _thoughts.add(thoughts);
      if (_containesDuplicates()) {
        print("WARNING: _thoughts containes duplicates");
      }
      return thoughts;
    }
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

  @override
  Widget build(BuildContext context) {
    Widget afterAppBar = _hasError
        ? SliverFillRemaining(
            child: Error(
              color: Theme.of(context).accentColor,
            ),
          )
        : SliverList(
            delegate: SliverChildBuilderDelegate(
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
            ),
          );

    return Scaffold(
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
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () => Navigator.pushNamed(context, "/about"),
                ),
              ],
            ),
            afterAppBar,
          ],
        ),
      ),
    );
  }
}
