import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './about_route.dart';
import '../models/thought.dart';
import '../ui_elements/thought_tile.dart';
import '../apis/reddit_api.dart';
import '../ui_elements/error.dart';
import '../scoped_model/main_model.dart';
import '../ui_elements/transitioner.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute>
    with SingleTickerProviderStateMixin {
  final Duration _tryDelay = Duration(milliseconds: 100);
  final int _triesBeforeTimeout = 100;

  bool _showSaved = false;
  AnimationController _showSavedAnim;

  @override
  initState() {
    super.initState();
    _showSavedAnim = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  Future<List<Thougth>> _getThoughts(int index, BuildContext context) async {
    MainModel model = MainModel.of(context);
    if (index < model.thoughts.length) return model.thoughts[index];
    model.getMore(index + 1);

    bool shouldCount = index == model.thoughts.length;
    int count = 0;
    while (index >= model.thoughts.length) {
      await Future.delayed(_tryDelay);
      if (shouldCount) {
        count++;
        if (count >= _triesBeforeTimeout) {
          model.callError();
          return null;
        }
      }
    }

    return model.thoughts[index];
  }

  Future _onRefresh(BuildContext context) async {
    MainModel.of(context).testInternet();
  }

  Widget _buildSavedListTile() {
    return ListTile(
      leading: Transitioner(
        animation: _showSavedAnim,
        child1: Icon(Icons.favorite_border),
        child2: Icon(Icons.lightbulb_outline),
      ),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Transitioner(
          animation: _showSavedAnim,
          child1: Text(
            "Saved",
            style: Theme.of(context).textTheme.subhead,
          ),
          child2: Text(
            "Thoughts",
            style: Theme.of(context).textTheme.subhead,
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
        _showSavedAnim.animateTo(_showSaved ? 0.0 : 1.0);
        setState(() {
          _showSaved = !_showSaved;
        });
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
            Center(
              child: Image.asset(
                "assets/shower.png",
                scale: 3.5,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(),
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
                future: _getThoughts(index, context),
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
            MainModel.of(context).saved.map((Thougth thought) {
              return ThoughtTile(thought: thought);
            }).toList(),
          );
  }

  Widget _buildAfterAppBar(BuildContext context) {
    return MainModel.of(context).hasError
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
      body: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          return RefreshIndicator(
            onRefresh: () => _onRefresh(context),
            notificationPredicate: (_) => model.hasError,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: 200.0,
                  floating: true,
                  flexibleSpace: Image.asset(
                    "assets/shower.png",
                    color: model.hasError
                        ? Theme.of(context).accentColor
                        : Theme.of(context).indicatorColor,
                  ),
                ),
                _buildAfterAppBar(context),
              ],
            ),
          );
        },
      ),
    );
  }
}
