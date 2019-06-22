import 'package:flutter/material.dart';

import '../models/thought.dart';
import '../ui_elements/thought_tile.dart';
import '../apis/reddit_api.dart';

class HomeRoute extends StatelessWidget {
  final Api _redditApi = Api();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return FutureBuilder(
                  future: _redditApi.nextThougths(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return ListView(
                        shrinkWrap: true,
                        primary: false,
                        children: List.generate(100, (int index) {
                          return ThoughtTile(
                            thought: null,
                          );
                        }),
                      );
                    } else {
                      final List<Thougth> data = snapshot.data;
                      return ListView(
                          shrinkWrap: true,
                          primary: false,
                          children: data.map(
                            (Thougth thought) {
                              return ThoughtTile(
                                thought: thought,
                              );
                            },
                          ).toList());
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
