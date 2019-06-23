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
        canvasColor: Colors.black,
        cardColor: Color(0xff212121),
        highlightColor: Color(0xff333333),
        appBarTheme: AppBarTheme(
          color: Colors.black,
        ),
        textTheme: TextTheme(
          title: TextStyle(
            fontWeight: FontWeight.w400,
          ),
          subtitle: TextStyle(
            color: Colors.deepPurple[300],
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
          headline: TextStyle(
            fontSize: 37.0,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      routes: {
        "/": (BuildContext context) => HomeRoute(),
      },
    );
  }
}
