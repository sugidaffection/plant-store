import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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
        title: Text("Shopping Cart"),
      ),
      body: user == null ? Center(child: CircularProgressIndicator()) : StreamBuilder(
        stream: db.collection("user").document(user.uid).collection("shopping_cart").snapshots(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            if(snapshot.data.documents.isNotEmpty){
              return Container();
            }

            return Center(child: Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text("Cart is empty", style: Theme.of(context).textTheme.headline5,),
                Text("Explore more and add some items"),
                SizedBox(height: 20),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: (){},
                  child: Text("Start Shopping", style: Theme.of(context).primaryTextTheme.button,),
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