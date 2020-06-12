import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {

  Stream<QuerySnapshot> stream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseAuth.instance.currentUser().then((value) {
      if (this.mounted) {
        setState(() {
          stream = Firestore.instance.collection("user").document(value.uid).collection("orders").snapshots();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders")
      ),
      body: StreamBuilder(
        stream: stream,
        builder: (context, snapshot){
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        List<DocumentSnapshot> docs = snapshot.data.documents;
        if (docs.isEmpty) return Center(child: Text("You don't have any order"));
        return ListView.separated(itemBuilder: (context, idx){
          var item = docs[idx].data;
          String date = DateTime.parse(item["order_date"].toDate().toString()).toString().split(" ")[0].replaceAll("-", "/");
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Order ID : ", style: theme.textTheme.subtitle1),
                  SizedBox(width: 15),
                  Text("${item["order_id"]}", style: theme.textTheme.subtitle1),
                  Spacer(),
                  Text(date, style: theme.textTheme.subtitle2.merge(TextStyle(color: Colors.black54))),
                ],
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Total Items", style: theme.textTheme.subtitle1.merge(TextStyle(color: Colors.black54))),
                  SizedBox(width: 15),
                  Text(item["order_items"].length.toString(), style: theme.textTheme.subtitle2),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Total Amount", style: theme.textTheme.subtitle1.merge(TextStyle(color: Colors.black54))),
                  SizedBox(width: 15),
                  Text("\$${item["order_amount"]}", style: theme.textTheme.subtitle1),
                ],
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("STATUS", style: theme.textTheme.subtitle1.merge(TextStyle(color: Colors.black54))),
                  SizedBox(width: 15),
                  Text("${item["order_status"]}", style: theme.textTheme.subtitle1.merge(TextStyle(
                    color: item["order_status"] == "Processing" ? Colors.indigo : item["order_status"] == "Transit" ? Colors.orange : item["order_status"] == "Received" ? Colors.green :  Colors.black
                  ))),
                ],
              ),
            ]
          );
        }, separatorBuilder: (context, idx) => Divider(height: 40,), itemCount: docs.length, padding: EdgeInsets.all(20) );
      })
    );
  }
}