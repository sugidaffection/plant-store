import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore db = Firestore.instance;

  FirebaseUser user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth.currentUser().then((value){
      setState(() {
        user = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Wishlist"),
      ),
      body: user == null ? Center(child: CircularProgressIndicator()) : StreamBuilder(
        stream: db.collection("user").document(user.uid).collection("wishlist").snapshots(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            if(snapshot.data.documents.isNotEmpty){
              return Container();
            }

            return Center(child: Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text("Wishlist is empty", style: Theme.of(context).textTheme.headline5,),
                Text("Explore more and save some items"),
                SizedBox(height: 20),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: (){},
                  child: Text("Explore Items", style: Theme.of(context).primaryTextTheme.button,),
                )
              ]
            ));
          }
          return Center(child: CircularProgressIndicator());
        }
      )
    );
  }
}