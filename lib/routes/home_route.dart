import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/thought.dart';
import '../ui_elements/thought_tile.dart';
import '../ui_elements/error.dart';
import '../scoped_model/main_model.dart';
import '../ui_elements/transitioner.dart';
import '../ui_elements/gradient button.dart';

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

  @override
  dispose() {
    _showSavedAnim.dispose();
    super.dispose();
  }

  Future<Thougth> _getThoughts(int index, BuildContext context) async {
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

  Widget _buildAboutListTile() {
    return ListTile(
      leading: Icon(Icons.mail),
      title: Text(
        "About me",
        style: Theme.of(context).textTheme.subhead,
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed("/about");
      },
    );
  }

  Widget _buildRedditListTile() {
    return ListTile(
      leading: Image.asset(
        "assets/reddit.png",
        scale: 22,
      ),
      title: Text(
        "r/Showerthoughts",
        style: Theme.of(context).textTheme.subhead,
      ),
      onTap: () async {
        Navigator.of(context).pop();
        final url = "https://www.reddit.com/r/Showerthoughts/";
        if (await canLaunch(url))
          await launch(url);
        else
          throw "Could not launch $url";
      },
    );
  }

  Widget _buildTermsListTile() {
    return ListTile(
      leading: Image.asset(
        "assets/terms.png",
        scale: 22,
      ),
      title: Text(
        "Terms",
        style: Theme.of(context).textTheme.subhead,
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed("/terms");
      },
    );
  }

  Widget _buildAdsButton() {
    return Center(
      child: GradientButton(
        onPressed: () {},
        gradient: LinearGradient(
          colors: [
            Theme.of(context).accentColor,
            Theme.of(context).indicatorColor,
          ],
          begin: FractionalOffset.centerLeft,
          end: FractionalOffset.centerRight,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.block),
            SizedBox(width: 6.0),
            Text(
              "Remove Ads",
              style: Theme.of(context).textTheme.button,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Material(
        color: Theme.of(context).cardColor,
        child: SingleChildScrollView(
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
              _buildRedditListTile(),
              _buildAboutListTile(),
              _buildTermsListTile(),
              SizedBox(height: 42.0),
              _buildAdsButton(),
              SizedBox(height: 75.0),
            ],
          ),
        ),
      ),
    );
  }

  SliverChildDelegate _buildSliverDelegate(BuildContext context) {
    return !_showSaved
        ? SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final List<Thougth> thoughts = MainModel.of(context).thoughts;
              if (index < thoughts.length) {
                return ThoughtTile(
                  thought: thoughts[index],
                );
              }
              return FutureBuilder(
                future: _getThoughts(index, context),
                builder: (context, AsyncSnapshot snapshot) {
                  return ThoughtTile(
                    thought: snapshot.connectionState == ConnectionState.done
                        ? snapshot.data
                        : null,
                  );
                },
              );
            },
          )
        : SliverChildListDelegate(
            MainModel.of(context).saved.map((Thougth thought) {
              return Container(
                child: ThoughtTile(thought: thought),
              );
            }).toList()
              ..add(Container(height: 105.0)),
          );
  }

  Widget _buildAfterAppBar(BuildContext context) {
    return MainModel.of(context).hasError && !_showSaved
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
