import 'package:flutter/material.dart';

import '../ui_elements/joke_tile.dart';

class HomeRoute extends StatelessWidget {
  Future _fetchJoke() async {
    await Future.delayed(Duration());
    return {
      "joke": "Hi hungry, im dad",
      'author': "dad",
    };
  }

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
                  future: _fetchJoke(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return JokeTile(joke: null);
                    } else {
                      return JokeTile(
                        joke: {
                          "joke":
                              "Hi hungry, im dad. And this is a really long showerthought. To be or not to be. That is the question. ",
                          'author': "dad",
                        },
                      );
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
