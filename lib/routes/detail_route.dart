import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../models/thought.dart';

class DetailRoute extends StatelessWidget {
  final Thougth thought;

  DetailRoute({@required this.thought}) : assert(thought != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 48.0, vertical: 28.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Hero(
                  tag: thought.id,
                  child: Image.asset("assets/shower.png", scale: 3),
                ),
                Container(
                  constraints: BoxConstraints.loose(Size(double.infinity, 192)),
                  child: AutoSizeText(
                    thought.thougth,
                    style: Theme.of(context).textTheme.display2,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 16.0),
                AutoSizeText(
                  "- ${thought.author}",
                  style: Theme.of(context).textTheme.display1,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
