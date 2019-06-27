import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:photos_saver/photos_saver.dart';

import '../models/thought.dart';
import '../scoped_model/main_model.dart';
import '../ui_elements/transitioner.dart';

class DetailRoute extends StatefulWidget {
  final Thougth thought;

  DetailRoute({@required this.thought}) : assert(thought != null);

  @override
  _DetailRouteState createState() => _DetailRouteState();
}

class _DetailRouteState extends State<DetailRoute>
    with SingleTickerProviderStateMixin {
  final GlobalKey _globalKey = new GlobalKey();
  bool _favorite;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _favorite = MainModel.of(context).saved.contains(widget.thought);
    _controller = AnimationController(
      vsync: this,
      value: _favorite ? 1.0 : 0.0,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveImage() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    await PhotosSaver.saveFile(
      fileData: byteData.buffer.asUint8List(),
    );
  }

  Widget _buildThoughtColumn() {
    return RepaintBoundary(
      key: _globalKey,
      child: Padding(
        padding: EdgeInsets.only(bottom: 22.0),
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
          ],
        ),
      ),
    );
  }

  Widget _buildButtonRow() {
    final double iconSize = 24.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Transitioner(
            animation: _controller,
            child1: Icon(Icons.favorite_border),
            child2: Icon(Icons.favorite),
          ),
          iconSize: iconSize,
          onPressed: () {
            if (_favorite) {
              MainModel.of(context).removeFromSaved(widget.thought);
            } else {
              MainModel.of(context).addToSaved(widget.thought);
            }
            setState(() => _favorite = !_favorite);
            _controller.animateTo(_favorite ? 1.0 : 0.0);
          },
        ),
        IconButton(
          icon: Icon(Icons.share),
          iconSize: iconSize,
          onPressed: () {
            Share.share(widget.thought.thougth);
          },
        ),
        IconButton(
          icon: Icon(Icons.file_download),
          iconSize: iconSize,
          onPressed: _saveImage,
        ),
        IconButton(
          icon: Icon(Icons.open_in_new),
          iconSize: iconSize,
          onPressed: () async {
            final String modifiedTitle =
                widget.thought.thougth.toLowerCase().replaceAll(" ", "_");
            final String url =
                "https://www.reddit.com/r/Showerthoughts/comments/${widget.thought.id}/$modifiedTitle/";
            if (await canLaunch(url)) await launch(url);
          },
        ),
      ],
    );
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
                _buildThoughtColumn(),
                _buildButtonRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
