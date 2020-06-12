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

  CollectionReference orderRef;
  List<DocumentSnapshot> cartList;

  DocumentReference userRef;
  int userPoints;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth.currentUser().then((value){
      if(this.mounted){
        setState(() {
          user = value;
          orderRef = db.collection("user").document(user.uid).collection("orders");
          userRef = db.collection("user").document(user.uid);
        });
      }

      db.collection("user").document(user.uid).snapshots().listen((event) {
        if(this.mounted) {
          setState(() {
            userPoints = event.data["points"] ?? 500;
          });
        }
      });

      db.collection("user").document(user.uid).collection("cart").snapshots().listen((event) {
        
        if (this.mounted) {
          setState(() {
            cartList = event.documents;
          });
        }

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
                    ...doc,
                    "item_ref": e.reference
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

  void createTransaction(Map<String, dynamic> data) {
    if(orderRef != null) {
      data["order_date"] = DateTime.now();
      data["order_status"] = "Processing";
      Firestore.instance.collectionGroup("orders").getDocuments().then((value){
        data["order_id"] = value.documents.length + 1;
        orderRef.add(data).then((value){
          if (cartList != null){
            var batch = Firestore.instance.batch();
            for (DocumentSnapshot doc in cartList) {
              batch.delete(doc.reference);
            }
            batch.commit();

            if (userRef != null) {
              userRef.updateData(
                {
                  "points" : userPoints + 300
                }
              );
            }
          }
        });
      });
    }
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
                    onPressed: (){
                      createTransaction({
                        "order_amount" : subtotal + 20,
                        "order_items" : items.map((e) => e["ref"]).toList()
                      });
                    },
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
                    Text(items[idx]["name"], style: Theme.of(context).textTheme.headline6,),
                    Row(
                      children: [
                        Text("\$${items[idx]["price"]}", style: Theme.of(context).textTheme.subtitle1),
                        Spacer(),
                        IconButton(
                          iconSize: 32,
                          icon: Icon(
                            Icons.remove_circle, 
                            color: Theme.of(context).accentColor,
                          ), 
                          onPressed: ()=>removeItem(items[idx])),
                        SizedBox(width: 10),
                        Text("${items[idx]["count"]}", style: Theme.of(context).textTheme.subtitle1,),
                        SizedBox(width: 10),
                        IconButton(
                          iconSize: 32,
                          icon: Icon(
                            Icons.add_circle, 
                            color: Theme.of(context).accentColor,

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