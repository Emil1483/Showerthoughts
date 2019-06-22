import 'package:flutter/material.dart';

import '../models/thought.dart';

class ThoughtTile extends StatelessWidget {
  final Thougth thought;
  ThoughtTile({@required this.thought});

  Widget _buildTitle(BuildContext context) {
    TextStyle style = Theme.of(context).textTheme.title;
    try {
      return Expanded(
        flex: 1,
        child: SingleChildScrollView(
          child: Text(
            thought.thougth,
            style: style,
          ),
        ),
      );
    } catch (_) {
      return Expanded(
        flex: 1,
        child: Container(
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            color: Theme.of(context).splashColor,
          ),
        ),
      );
    }
  }

  Widget _buildSubtitle(BuildContext context) {
    TextStyle style = Theme.of(context).textTheme.subtitle;
    try {
      return Expanded(
        flex: 0,
        child: Text(
          thought.author,
          style: style,
        ),
      );
    } catch (_) {
      return Expanded(
        flex: 0,
        child: Container(
          height: style.fontSize,
          width: 102.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            color: Theme.of(context).splashColor,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 144.0,
      padding: EdgeInsets.symmetric(
        horizontal: 22.0,
        vertical: 12.0,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildTitle(context),
          SizedBox(height: 10.0),
          _buildSubtitle(context),
        ],
      ),
    );
  }
}
