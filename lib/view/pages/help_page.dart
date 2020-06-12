import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {

  final TextEditingController chatController = TextEditingController();
  CollectionReference chatRef;

  FirebaseUser user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseAuth.instance.currentUser().then((value) {
        setState(() {
          user = value;
          chatRef = Firestore.instance.collection("chatsupport")
            .where("user", isEqualTo: value.uid)
            .where("receiver", isEqualTo: value.uid)
            .reference();
        });
    });
  }

  void submit() {
    if(chatController.text.trim().isNotEmpty && user != null) {
      chatRef.add({
        "user": user.uid,
        "message": chatController.text
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Support"),
      ),
      body: chatRef == null ?  Center(child: CircularProgressIndicator()) : StreamBuilder(
        stream: chatRef.snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) 
            return Column(
              children: <Widget>[
                Expanded(child: Center(child: Text("Please wait..."))),
              ],
            );

        List<DocumentSnapshot> items = snapshot.data.documents;
        return Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, idx){
                    if(items[idx].data.containsKey("user")){
                      return Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(items[idx].data["message"])
                          ],
                        ),
                      );
                    }
                    if(items[idx].data.containsKey("receiver")){
                      return Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(items[idx].data["staff"]),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white70
                              ),
                              padding: EdgeInsets.all(10),
                              child: Text(items[idx].data["message"]),
                            )
                            
                          ],
                        ),
                      );
                    }
                  return Container();
                }),
              ),
              Container(
                padding: EdgeInsets.all(10),
                color: Theme.of(context).primaryColor,
                child: Row(
                children: <Widget>[
                  Expanded(child: Container(
                    color: Colors.white,
                    child: TextField(
                      controller: chatController,
                      decoration: InputDecoration(
                        hintText: "Chat...",
                        contentPadding: EdgeInsets.all(10)
                      ),
                    ))),
                  IconButton(icon: Icon(Icons.send), onPressed: (){
                    submit();
                  },)
                ],
              ))
            ],
          );;
      }),
    );
  }
}