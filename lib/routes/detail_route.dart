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
      body: Center(
        child: Text(thought.thougth),
      ),
    );
  }
}
