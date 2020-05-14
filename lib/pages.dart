import 'package:flutter/material.dart';
import 'package:plant_store/view/main_page.dart';
import 'package:plant_store/view/profile_page.dart';


class Pages extends StatefulWidget {

  const Pages({Key key}) : super(key: key);

  @override
  _PagesState createState() => _PagesState();
}

class _PagesState extends State<Pages> {

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
          selectedItemColor: Theme.of(context).primaryColor,
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
