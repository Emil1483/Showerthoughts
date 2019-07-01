import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../scoped_model/main_model.dart';
import '../models/thought.dart';
import './loading_rect.dart';
import '../routes/detail_route.dart';
import './heart_splash.dart';

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
                child: AutoSizeText(
                  thought.thougth,
                  style: style,
                  maxLines: 5,
                  minFontSize: 18,
                  overflow: TextOverflow.ellipsis,
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
    final double iconSize = 52.0;
    final BorderRadius borderRadius = BorderRadius.circular(8.0);
    return Container(
      height: 182.0,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: borderRadius,
      ),
      margin: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        top: 22.0,
      ),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: borderRadius,
            child: Material(
              type: MaterialType.transparency,
              child: HeartSplash(
                color: Colors.red,
                child: Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onLongPressStart: (details) {
                        final RenderBox referenceBox =
                            context.findRenderObject();
                        final Offset pos =
                            referenceBox.globalToLocal(details.globalPosition);
                        HeartSplash.of(context).animate(pos: pos);
                        Feedback.forLongPress(context);
                        MainModel.of(context).addToSaved(thought);
                      },
                      child: InkWell(
                        onTap: thought != null
                            ? () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailRoute(thought: thought),
                                  ),
                                );
                              }
                            : null,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 22.0,
                            vertical: 12.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _buildTitle(context),
                              _buildSubtitle(context),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          thought != null
              ? Transform.translate(
                  offset: Offset(0, -iconSize / 2),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: iconSize,
                      width: iconSize,
                      child: Hero(
                        tag: thought.id,
                        child: Image.asset(
                          "assets/shower.png",
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
