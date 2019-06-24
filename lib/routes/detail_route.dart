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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 64.0),
          alignment: Alignment.center,
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                thought.thougth,
                style: Theme.of(context).textTheme.display1,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
