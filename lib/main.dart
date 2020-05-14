import 'dart:async';

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
        textTheme: TextTheme()
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
  bool _isLoading = true;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  var timer;

  checkAuth() async {
    sharedPreferences = await SharedPreferences.getInstance();
    Timer(Duration(milliseconds: 500), (){
      setState(() {
        _isLoading = false;
        
      });

      if (sharedPreferences.getString("token") == null) {
        Navigator.of(context).pushReplacementNamed("/login");
      }else{
        Navigator.of(context).pushReplacementNamed("/main");
      }
    });
    
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator())
    );
  }
}
