import 'package:flutter/material.dart';
import 'package:plant_store/home.dart';
import 'package:plant_store/login.dart';
import 'package:plant_store/profile.dart';

void main() => runApp(MainApp());

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  bool loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: loggedIn ? MainPage() : LoginPage(),
      routes: {
        "/profile" : (context) => ProfilePage()
      },
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int currentIndex = 0;
  Widget page = HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (idx) {
          setState(() {
            currentIndex = idx;

            switch (idx) {
              case 0:
                page = HomePage();
                break;
              case 3:
                // Navigator.of(context).pushNamed("/profile").then((value){
                //   currentIndex = 0;
                // });
                  page = ProfilePage();
                break;
              default:
            }
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home"),),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), title: Text("Whislist")),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_basket), title: Text("Cart")),
          BottomNavigationBarItem(icon: Icon(Icons.person), title: Text("Profile")),
      ]),
    );
  }
}