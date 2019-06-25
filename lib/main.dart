import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './routes/home_route.dart';
import './routes/about_route.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
    ),
  );
  runApp(MyApp());
}

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
        accentColor: Colors.deepPurpleAccent[200],
        indicatorColor: Colors.deepPurple[200],
        appBarTheme: AppBarTheme(
          color: Colors.black,
        ),
        textTheme: TextTheme(
          title: TextStyle(
            fontWeight: FontWeight.w400,
          ),
          display2: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 26.0,
          ),
          display1: TextStyle(
            fontWeight: FontWeight.w300,
            color: Colors.white,
            fontSize: 22.0,
            fontStyle: FontStyle.italic,
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
        "/about": (BuildContext context) => AboutRoute(),
      },
    );
  }
}
