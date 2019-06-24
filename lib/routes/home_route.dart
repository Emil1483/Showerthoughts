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
      return thoughts;
    }
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
            child: Error(),
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
              flexibleSpace: Image.asset("assets/shower.png"),
            ),
            afterAppBar,
          ],
        ),
      ),
    );
  }
}
