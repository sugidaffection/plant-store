import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantstore/view/pages/cart_page.dart';
import 'package:plantstore/view/pages/main_page.dart';
import 'package:plantstore/view/pages/profile_page.dart';
import 'package:plantstore/view/pages/wishlist_page.dart';


class Pages extends StatefulWidget {

  const Pages({Key key}) : super(key: key);

  @override
  _PagesState createState() => _PagesState();
}

class _PagesState extends State<Pages> {

  var currentIndex = 0;

  Widget selectedPage = HomePage();

  FirebaseUser user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseAuth.instance.currentUser()
      .then((value) => setState(() => user = value));
      
  }

  void logout() async{
    FirebaseAuth.instance.signOut();
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: selectedPage is HomePage ? AppBar(title: Text("Plant Store"), actions: [
          IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () => Navigator.of(context).pushNamed("/search")
            )
        ]) : null,
        drawer: selectedPage is HomePage == false ? null : Drawer(
          child: Padding(
            padding: EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
            child: Column(
              children: [
                Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 20,
                    children: [
                      user?.photoUrl != null ? 
                      CircleAvatar(child: Image.network(user?.photoUrl)) : 
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.black12
                        ),
                        child: Icon(Icons.person, size: 32, color: Colors.black54,)
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.displayName ?? "", style: Theme.of(context).textTheme.headline6),
                        Text(user?.email ?? "", style: Theme.of(context).textTheme.caption),
                      ]
                  ),])
                ),
                SizedBox(height: 40),
                Container(
                  width: width,
                  child: 
                    FlatButton(
                    onPressed: (){}, 
                    child: 
                    Row(
                      children: [
                        Icon(Icons.assignment, color: Colors.black87),
                        SizedBox(width: 20,),
                        Text("My Orders", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),)
                      ])),
                  ),
                  Container(
                  width: width,
                  child: 
                    FlatButton(
                    onPressed: (){}, 
                    child: 
                    Row(
                      children: [
                        Icon(Icons.credit_card, color: Colors.black87),
                        SizedBox(width: 20,),
                        Text("Card Center", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),)
                      ])),
                  ),
                  Container(
                  width: width,
                  child: 
                    FlatButton(
                    onPressed: (){}, 
                    child: 
                    Row(
                      children: [
                        Icon(Icons.headset_mic, color: Colors.black87),
                        SizedBox(width: 20,),
                        Text("Help", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),)
                      ])),
                  ),
                  Spacer(),
                  Divider(),
                  FlatButton(onPressed: logout, child: 
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 20,
                    children: [
                      Icon(Icons.power_settings_new, color: Colors.black54),
                      Text("Logout", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),)
                    ]))
              ],
              
            )
          )
        ),
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
                case 1:
                  selectedPage = WishlistPage();
                  break;
                case 2:
                  selectedPage = CartPage();
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
