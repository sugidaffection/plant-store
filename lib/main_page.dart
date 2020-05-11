import 'package:flutter/material.dart';

import 'home.dart';
import 'profile.dart';

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
