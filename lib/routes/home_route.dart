import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../ui_elements/joke_tile.dart';

class HomeRoute extends StatelessWidget {
  Future _fetchPage() async {
    await Future.delayed(Duration(seconds: 1));
    return List.generate(10, (index) {
      return {
        "joke": "Hi hungry, im dad",
        'author': "dad",
      };
    });
  }

  Widget _buildPage(List<Map<String, dynamic>> data) {
    return ListView(
      shrinkWrap: true,
      primary: false,
      children: data.map((Map<String, dynamic> productInfo) {
        return ListTile(
          leading: Icon(Icons.shopping_cart),
          title: Text(productInfo['name']),
          subtitle: Text('price: ${productInfo['price']}USD'),
        );
      }).toList(),
    );
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
                return JokeTile(
                  joke: math.Random().nextDouble() > 0.5
                      ? null
                      : {
                          "joke": "Hi hungry, im dad. And this is a really long showerthought. To be or not to be. That is the question. ",
                          'author': "dad",
                        },
                );
              },
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          ListView.builder(
            primary: false,
            itemBuilder: (BuildContext context, int index) {
              return FutureBuilder(
                future: _fetchPage(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 3,
                      alignment: Alignment.topCenter,
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }

                  List<Map<String, dynamic>> data = snapshot.data;
                  return ListView(
                    shrinkWrap: true,
                    primary: false,
                    children: data.map((Map<String, dynamic> joke) {
                      return ListTile(
                        title: Text(joke['joke']),
                        subtitle: Text(joke["author"]),
                      );
                    }).toList(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
