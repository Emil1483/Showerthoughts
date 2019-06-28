import 'package:flutter/material.dart';

class TermsRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text("Terms"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Text(
            """
The content held within this app is pulled from reddit.com/r/showerthoughts.

As such, I have no control over the content of this app and I am therefore not responsible for anything you may find offensive, libelous or otherwise.

I have no affiliation with the moderation team at r/showerthoughts.
""",
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.grey.shade300,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
