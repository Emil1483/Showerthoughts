import 'package:flutter/material.dart';

import './routes/home_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shower Thoughts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: TextTheme(
          title: TextStyle(
            fontWeight: FontWeight.w400,
          ),
          subtitle: TextStyle(
            color: Colors.white54,
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      routes: {
        "/": (BuildContext context) => HomeRoute(),
      },
    );
  }
}
