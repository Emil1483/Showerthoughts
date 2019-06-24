import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';

import '../models/thought.dart';
import './loading_rect.dart';

class ThoughtTile extends StatelessWidget {
  final Thougth thought;
  ThoughtTile({@required this.thought});

  final double highlightOpacity = 0.8;

  Widget _buildTitle(BuildContext context) {
    TextStyle style = Theme.of(context).textTheme.title;
    bool loading = thought == null || thought.thougth == null;
    return Expanded(
      flex: 1,
      child: Container(
        margin: loading
            ? EdgeInsets.symmetric(vertical: 16.0)
            : EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.0),
        ),
        child: loading
            ? LoadingRect(
                mainColor: Theme.of(context).highlightColor,
                secColor: Theme.of(context)
                    .highlightColor
                    .withOpacity(highlightOpacity),
              )
            : Center(
                child: SingleChildScrollView(
                  child: AutoSizeText(
                    thought.thougth,
                    style: style,
                    maxLines: 5,
                    minFontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    TextStyle style = Theme.of(context).textTheme.subtitle;
    bool loading = thought == null || thought.author == null;

    return Container(
      height: loading ? style.fontSize : null,
      width: loading ? 102.0 : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: loading
          ? LoadingRect(
              mainColor: Theme.of(context).highlightColor,
              secColor: Theme.of(context)
                  .highlightColor
                  .withOpacity(highlightOpacity),
            )
          : Text(
              "- ${thought.author}",
              style: style,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 172.0,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTitle(context),
          _buildSubtitle(context),
        ],
      ),
    );
  }
}
