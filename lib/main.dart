import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plant_store/items.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:plant_store/login.dart';
import 'package:plant_store/main_page.dart';
import 'package:plant_store/profile.dart';
import 'package:plant_store/register.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainApp(),
      routes: {
        "/main": (context) => MainPage(),
        "/profile": (context) => ProfilePage(),
        "/register": (context) => RegisterPage(),
        "/login": (context) => LoginPage(),
        "/items": (context) => ItemPage(),
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
