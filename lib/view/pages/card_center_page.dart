import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CardCenterPage extends StatefulWidget {
  @override
  _CardCenterPageState createState() => _CardCenterPageState();
}

class _CardCenterPageState extends State<CardCenterPage> {

  Stream<DocumentSnapshot> stream;
  DocumentReference ref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    FirebaseAuth.instance.currentUser().then((value){
      if(this.mounted){
        setState(() {
          ref = Firestore.instance.collection("user").document(value.uid);
          stream = ref.snapshots();
        });
      }
    });

  }

  void createNewCard() {
    if(ref != null){
      setState(() {
        ref.updateData({
          "cards": FieldValue.arrayUnion(["1234 1234 1234 1234"])
        });
      });
    }
  }

   void removeCard(String card) {
    if(ref != null){
      setState(() {
        ref.updateData({
          "cards": FieldValue.arrayRemove([card])
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Card Center"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: (){},
          )
        ],
      ),
      body: StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          List<dynamic> docs = snapshot.data["cards"];
          if (docs == null || docs.isEmpty) return Container(
            padding: EdgeInsets.all(20),
            width: size.width,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Center(child: 
                    Center(child: Text("Empty Cards", style: theme.textTheme.headline6))
                  )),
                  RaisedButton(onPressed: (){
                    createNewCard();
                  }, child: Text("Add new card"), color: theme.primaryColor, textColor: Colors.white,)
                ],
              ),
          );
          
          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 20),
            itemCount: docs.length + 1,
            padding: EdgeInsets.all(20),
            itemBuilder: (context, index) {
              if(index == docs.length) return RaisedButton(onPressed: (){ createNewCard();}, child: Text("Add new card"), color: theme.primaryColor, textColor: Colors.white,);
              return GestureDetector(
                onHorizontalDragEnd: (detail) {
                  if (detail.velocity.pixelsPerSecond.dx < 0) {
                    removeCard(docs[index]);
                  }
                },
            child: 
              Container(
                  height: size.width / 2.75,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Bank Name", style: theme.primaryTextTheme.subtitle1.merge(TextStyle(fontWeight: FontWeight.bold))),
                      Wrap(
                        spacing: 20,
                        children: List.generate(docs[index].toString().split(" ").length, (idx) {
                          return Text(
                            docs[index].toString().split(" ")[idx],
                            style: theme.primaryTextTheme.headline5.merge(TextStyle(color: Colors.white70))
                            );
                        })
                      ),
                      Text(
                        "12 / 24",
                        style: theme.primaryTextTheme.subtitle2
                      )
                    ]
                  )),
                ),
                
              
              );
              
            },
          );
        },
      )
    );
  }
}