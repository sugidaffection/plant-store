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

  List<Map<String, dynamic>> items;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth.currentUser().then((value){
      setState(() {
        user = value;
      });

      db.collection("user").document(user.uid).collection("cart").where("count", isGreaterThan: 0).snapshots().listen((event) {
        List<String> refPath = event.documents.map<String>((e) => e.data["ref"].documentID).toList();
        List<Map<String, dynamic>> docs = event.documents.map((e) => {
          "path" : e.data["ref"].path,
          "count" : e.data["count"],
          "ref": e.reference
        }).toList();

        if (refPath.isNotEmpty)
          db.collection("items").where(FieldPath.documentId, whereIn: refPath).getDocuments().then((value){
            if(this.mounted)
              setState(() {
                items = value.documents.map<Map<String, dynamic>>((e){
                  var doc = docs.where((element) => element["path"] == e.reference.path).first;
                  return {
                    ...e.data,
                    ...doc
                  };
              }).toList();
          });
          
          });
        else
          if(this.mounted)
            setState(() {
              items = [];
            });
        });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void addItem(item) {
    item["ref"].updateData({
      "count": item["count"] + 1
    });
  }

  void removeItem(item) {
    if(item["count"] - 1 > 0)
      item["ref"].updateData({
        "count": item["count"] - 1
      });
    else item["ref"].delete();
  }

  Widget createTransactionView(){
    var subtotal = items.map((e) => e["count"] * e["price"]).fold(0, (prev, curr) => prev + curr);
    return Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: <Widget>[
            Divider(),
                Row(
                  children: <Widget>[
                    Text("Subtotal"),
                    Spacer(),
                    Text("\$$subtotal")
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("Courier"),
                    Spacer(),
                    Text("\$20")
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("Total", style: Theme.of(context).textTheme.headline6),
                    Spacer(),
                    Text("\$${subtotal + 20}", style: Theme.of(context).textTheme.headline6)
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    onPressed: (){},
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                    child: Text("Purchase"),
                  )
                )],
            ));
  }

  Widget createListCart() {
    
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 20),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, idx) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(items[idx]["images"][0], height: 60, width: 60, fit: BoxFit.cover,),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(items[idx]["name"]),
                    Row(
                      children: [
                        Text("\$${items[idx]["price"]}", style: Theme.of(context).textTheme.headline6),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.remove_circle, 
                            color: Theme.of(context).accentColor,
                            size: 32,
                          ), 
                          onPressed: ()=>removeItem(items[idx])),
                        SizedBox(width: 10),
                        Text("${items[idx]["count"]}", style: Theme.of(context).textTheme.subtitle1,),
                        SizedBox(width: 10),
                        IconButton(
                          icon: Icon(
                            Icons.add_circle, 
                            color: Theme.of(context).accentColor,
                            size: 32,
                          ), 
                          onPressed: ()=>addItem(items[idx])),
                      ]
                    )
                  ]
              )),
            ]
          );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Shopping Cart"),
      ),
      body: user == null ? Center(child: CircularProgressIndicator()) : 
            items == null || items.isEmpty ? Center(child: Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text("Cart is empty", style: Theme.of(context).textTheme.headline5,),
                Text("Explore more and add some items"),
                SizedBox(height: 20),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: (){
                    Navigator.pushNamed(context, "/items", arguments: "Explore");
                  },
                  child: Text("Start Shopping", style: Theme.of(context).primaryTextTheme.button,),
                )
              ]
            )) : Column(
              children: <Widget>[
                Expanded(
                  child: createListCart()
                ),
                createTransactionView()
              ],
            )
      
    );
  }
}