import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plant_store/pages.dart';
import 'package:plant_store/view/item_page.dart';
import 'package:plant_store/view/login_page.dart';
import 'package:plant_store/view/profile_page.dart';
import 'package:plant_store/view/register_page.dart';
import 'package:plant_store/view/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    var routes = {
        "/main": (context) => Pages(),
        "/profile": (context) => ProfilePage(),
        "/register": (context) => RegisterPage(),
        "/login": (context) => LoginPage(),
        "/items": (context) => ItemPage(),
        "/search": (context) => SearchPage(),
      };
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.green,
        ),
        primaryColor: Colors.green,
        accentColor: Colors.greenAccent,
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.green
        ),
        fontFamily: "Poppins"
      ),
      home: MainApp(),

      onGenerateRoute: (settings) {
        if(settings.name == "/items"){
          return CupertinoPageRoute(builder: (context) => ItemPage(), settings: settings);
        }

        if(settings.name == "/search"){
          return PageRouteBuilder(
            pageBuilder: (_,__,___) => SearchPage(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            settings: settings,
          );
        }
        return MaterialPageRoute(builder: (context) => routes[settings.name](context), settings: settings);
      },
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot){
          if(snapshot.hasData)
              return Pages();
          return LoginPage();
        }
      )
    );
  }
}
