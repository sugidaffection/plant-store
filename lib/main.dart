import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plantstore/view/auth/reset_password.dart';
import 'package:plantstore/view/pages/cart_page.dart';
import 'package:plantstore/view/pages/item_detail_page.dart';
import 'package:plantstore/view/pages/pages.dart';
import 'package:plantstore/view/pages/item_page.dart';
import 'package:plantstore/view/auth/login/login_page.dart';
import 'package:plantstore/view/pages/profile_page.dart';
import 'package:plantstore/view/auth/register/register_page.dart';
import 'package:plantstore/view/pages/search_page.dart';

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
        "/resetPassword": (context) => ResetPassword(),
        "/itemDetail": (context) => ItemDetailPage(),
        "/cart": (context) => CartPage()
      };
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.green,
        ),
        primaryColor: Colors.green,
        accentColor: Colors.amberAccent,
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.green
        ),
        fontFamily: "Poppins"
      ),
      home: Scaffold(
      body: MainPage()
    ),
    onGenerateRoute: (settings) {
      if(["/items", "/register"].contains(settings.name)){
        return CupertinoPageRoute(builder: (context) => routes[settings.name](context), settings: settings);
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


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot){
          if(snapshot.hasData) { 
            return Pages();
          }
          return LoginPage();
        }
      
    );
  }
}