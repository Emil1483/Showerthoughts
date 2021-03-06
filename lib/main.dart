import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_admob/firebase_admob.dart';

import './routes/home_route.dart';
import './routes/about_route.dart';
import './routes/terms_route.dart';
import './scoped_model/main_model.dart';
import './advert_ids.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  MainModel _mainModel;

  @override
  void initState() {
    super.initState();
    _mainModel = MainModel();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _mainModel.saveData();
      _mainModel.scheduleNotification();
    } else if (state == AppLifecycleState.resumed) {
      _mainModel.cancelAllNotifications();
    }
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mainModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAdMob.instance.initialize(appId: AdvertIds.appId);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
      ),
    );
    return ScopedModel<MainModel>(
      model: _mainModel,
      child: MaterialApp(
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
            button: TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.white,
              fontSize: 21.0,
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
          "/terms": (BuildContext context) => TermsRoute(),
        },
      ),
    );
  }
}
