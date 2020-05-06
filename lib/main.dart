import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plant_store/home.dart';
import 'package:plant_store/login.dart';
import 'package:plant_store/profile.dart';
import 'package:plant_store/register.dart';

void main() => runApp(MainApp());

class MainApp extends StatefulWidget {
  
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: {
        "/main": (context) => MainPage(),
        "/profile": (context) => ProfilePage(),
        "/register": (context) => RegisterPage(),
        "/login": (context) => LoginPage()
      },
    );
  }
}

class MainPage extends StatefulWidget {

  const MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  var currentIndex = 0;

  Widget selectedPage = HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: selectedPage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: (idx) {
            currentIndex = idx;
            setState(() {
              switch (idx) {
                case 0:
                  selectedPage = HomePage();
                  break;
                case 3:
                  selectedPage = ProfilePage();
                  break;
                default:
              }
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), title: Text("Whislist")),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_basket), title: Text("Cart")),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text("Profile")),
          ]),
    );
  }
}
