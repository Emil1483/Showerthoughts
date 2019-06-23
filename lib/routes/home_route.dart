import 'package:flutter/material.dart';

import '../models/thought.dart';
import '../ui_elements/thought_tile.dart';
import '../apis/reddit_api.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  final Api _redditApi = Api();

  bool _hasError = false;

  Future<List<Thougth>> _getThoughts() async {
    final thoughts = await _redditApi.nextThougths();
    print(thoughts);
    if (thoughts == null) {
      setState(() {
        _hasError = true;
      });
      return null;
    }
    return thoughts;
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
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 100.0,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
          )
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return FutureBuilder(
                  future: _getThoughts(),
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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: true,
            flexibleSpace: Image.asset("assets/shower.png"),
          ),
          afterAppBar,
        ],
      ),
    );
  }
}
