import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantstore/model/user.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore db = Firestore.instance;

  FirebaseUser user;
  UserForm userDetail = UserForm();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    auth.currentUser().then((value){
      setState(() {
        user = value;
      });

      db.collection("user").document(value.uid).get().then((value){
        setState(() {
          var data = value.data;
          userDetail.address = data["address"];
          userDetail.phone = data["phone"];
        });
      });
    });

  }

  Widget createTileList({String header, String value}){
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(header, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
              ),
              Text(value, style: Theme.of(context).textTheme.bodyText1.merge(
                TextStyle(letterSpacing: 1)
              ),)
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("My Profile"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Column(children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(user?.photoUrl ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQT7NvIfTyhEXEDqrGjBe6Vaak8FpF2sOThf6pkUGkhdvPeYJ-A&usqp=CAU"),
              radius: 45,
            ),
            Text(user?.displayName ?? "", style: Theme.of(context).textTheme.headline5),
            Text(user?.email ?? "", style: Theme.of(context).textTheme.bodyText2)
          ],),
          SizedBox(height: 40),
          createTileList(header: "Mobile", value: userDetail?.phone ?? ""),
          SizedBox(height: 20),
          createTileList(header: "Address", value: userDetail?.address ?? ""),
        ]
      ),
    );
  }
}