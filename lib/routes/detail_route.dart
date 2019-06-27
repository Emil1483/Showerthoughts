import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

import '../models/thought.dart';
import '../scoped_model/main_model.dart';

class DetailRoute extends StatefulWidget {
  final Thougth thought;

  DetailRoute({@required this.thought}) : assert(thought != null);

  @override
  _DetailRouteState createState() => _DetailRouteState();
}

class _DetailRouteState extends State<DetailRoute> {
  bool favorite;

  _DetailRouteState();

  @override
  void initState() {
    super.initState();
    favorite = MainModel.of(context).saved.contains(widget.thought);
  }

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
                  tag: widget.thought.id,
                  child: Image.asset("assets/shower.png", scale: 3),
                ),
                Container(
                  constraints: BoxConstraints.loose(Size(double.infinity, 192)),
                  child: AutoSizeText(
                    widget.thought.thougth,
                    style: Theme.of(context).textTheme.display2,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 16.0),
                AutoSizeText(
                  "- ${widget.thought.author}",
                  style: Theme.of(context).textTheme.display1,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: favorite
                          ? Icon(Icons.favorite)
                          : Icon(Icons.favorite_border),
                      onPressed: () {
                        if (favorite) {
                          MainModel.of(context).removeFromSaved(widget.thought);
                        } else {
                          MainModel.of(context).addToSaved(widget.thought);
                        }
                        setState(() => favorite = !favorite);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () {
                        Share.share(widget.thought.thougth);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.open_in_new),
                      onPressed: () async {
                        final String modifiedTitle = widget.thought.thougth
                            .toLowerCase()
                            .replaceAll(" ", "_");
                        final String url =
                            "https://www.reddit.com/r/Showerthoughts/comments/${widget.thought.id}/$modifiedTitle/";
                        if (await canLaunch(url)) await launch(url);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
