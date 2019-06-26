import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutRoute extends StatelessWidget {
  final List<String> skills = [
    "Use an API",
    "Use git and github",
    "Build beutiful UI in flutter",
    "Make unbelievably good animations in flutter",
    "Handle errors in flutter",
    "Write general purpose code",
    "Use spritewidget to build games",
    "Build simulations based on real physics",
    "Use scoped model (a state management system)"
  ];

  @override
  Widget build(BuildContext context) {
    Widget headline = Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        "Why Does This App Exist?",
        style: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );

    Widget body = Padding(
      padding: EdgeInsets.only(bottom: 24.0),
      child: Text(
        "This app is the 4th app of my portfolio; If you need a flutter developer, send me an email! My portfolio apps are proof that I can:",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.grey.shade400,
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.center,
      ),
    );

    Widget bulletPoints = Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: skills.map((String skill) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
            margin: EdgeInsets.symmetric(vertical: 1.5),
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(4.0)),
            child: AutoSizeText(
              skill,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.subhead,
              maxLines: 1,
            ),
          );
        }).toList(),
      ),
    );

    Widget text = ListView(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      children: <Widget>[
        headline,
        body,
        bulletPoints,
      ],
    );

    Widget fab = FloatingActionButton(
      backgroundColor: Theme.of(context).accentColor,
      onPressed: () async {
        final url = "mailto:emil14833@gmail.com";
        if (await canLaunch(url))
          await launch(url);
        else
          throw "Could not launch $url";
      },
      child: Icon(Icons.mail_outline),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
      ),
      body: text,
      floatingActionButton: fab,
    );
  }
}
