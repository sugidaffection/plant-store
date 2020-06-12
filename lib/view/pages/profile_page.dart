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

  Map<String, dynamic> doc;

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
          doc = data;
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
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("My Profile"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Column(children: <Widget>[
            user?.photoUrl == null ? Icon(Icons.account_circle, color: Colors.black38, size: 85) : CircleAvatar(
              backgroundImage: NetworkImage(user?.photoUrl),
              radius: 45,
            ),
            Text(user?.displayName ?? "", style: Theme.of(context).textTheme.headline5),
            Text(user?.email ?? "", style: Theme.of(context).textTheme.bodyText2),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${doc != null && doc["points"] != null ? doc["points"] : 500} Pts", style: theme.textTheme.headline5.merge(TextStyle(color: Colors.black54))),
                Container(width: 40, height: 40, child: VerticalDivider(color: Colors.black12, thickness: 1.3,)),
                Text("\$${doc != null && doc["balance"] != null ? doc["balance"] : 0.00}", style: theme.textTheme.headline5.merge(TextStyle(color: Colors.black54))),
              ]
            )
          ],
          ),
          SizedBox(height: 30),
          Text("My Account", style: theme.textTheme.headline6.merge(TextStyle(color: Colors.black54)),),
          Padding(padding: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              createTileList(header: "Mobile", value: userDetail?.phone ?? ""),
              SizedBox(height: 3),
              createTileList(header: "Membership", value: "Silver"),
              ]
            )
          ),
        SizedBox(height: 20),
          Text("Personal Information", style: theme.textTheme.headline6.merge(TextStyle(color: Colors.black54)),),
          Padding(padding: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              createTileList(header: "Address", value: userDetail?.address ?? "street 123"),
              SizedBox(height: 3),
              createTileList(header: "City", value: userDetail?.city ?? "New York"),
              SizedBox(height: 3),
              createTileList(header: "Country", value: userDetail?.city ?? "USA"),
              ]
            )
          ),
          SizedBox(height: 20),
          RaisedButton(
            color: theme.primaryColor,
            textColor: theme.primaryTextTheme.button.color,
            onPressed: (){}, 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.edit),
              SizedBox(width: 10),
              Text("Edit Profile")
            ],
          ))
        ]
      ),
    );
  }
}