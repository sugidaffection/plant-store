import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantstore/view/card.dart';
import 'package:plantstore/view/rating.dart';

class ItemPage extends StatefulWidget {
  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {

  FirebaseUser user;
  List<String> wishlist;
  CollectionReference wishlistRef;

  CollectionReference cartRef;

  List<Map<String, dynamic>> cart;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseAuth.instance.currentUser().then((value) {
      setState(() {
        user = value;
      });
      wishlistRef = Firestore.instance.collection("user").document(user.uid).collection("wishlist").reference();
      wishlistRef.snapshots().listen((event) {
        if(this.mounted)
          setState(() {
              wishlist = event.documents.map<String>((e) => e.data["ref"].path).toList();
          });
      });

      cartRef = Firestore.instance.collection("user").document(user.uid).collection("cart").reference();
      cartRef.snapshots().listen((event) {
        if(this.mounted)
          setState(() {
            cart = event.documents.map((e) => {
              "ref": e.reference,
              "path": e.data["ref"].path,
              "count": e.data["count"]
            }).toList();
          });
      });

    });
  }

  void addToWishlist(DocumentSnapshot item) {
    if(this.mounted)
      setState(() {
        if(wishlist.contains(item.reference.path))
          wishlistRef.document(item.documentID).delete();
        else
          wishlistRef.document(item.documentID).setData({
            "ref" : item.reference
          });
      });
  }

  void addItemToCart(DocumentSnapshot item) {
    if(this.mounted)
      setState(() {
        if(cartRef != null)
        cartRef.document(item.reference.documentID).setData({
          "ref": item.reference,
          "count": 1
        });
      });
  }

  void addItem(item) {
    if(this.mounted && cart != null){
      Iterable<Map<String, dynamic>> listref = cart.where((element) => element["path"] == item.reference.path);
      if(listref.isNotEmpty)
        setState(() {
          if(listref.first != null)
            listref.first["ref"].updateData({
              "count": listref.first["count"] + 1
            });
        });
    }
      
  }
  
  void removeItem(item) {
    if(this.mounted && cart != null){
      Iterable<Map<String, dynamic>> listref = cart.where((element) => element["path"] == item.reference.path);
      if(listref.isNotEmpty)
        setState(() {
          if(listref.first != null)
            if(listref.first["count"] - 1 > 0)
              listref.first["ref"].updateData({
                "count": listref.first["count"] - 1
              });
            else listref.first["ref"].delete();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Object args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(args.toString()),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.shopping_cart), onPressed: (){
              Navigator.of(context).pushNamed("/cart");
            })
          ],
        ),
        body:StreamBuilder(
              stream: Firestore.instance.collection("items").snapshots(),
              builder: (context, snapshot) {
                if(!snapshot.hasData){return Center(child: CircularProgressIndicator());}
                if(snapshot.data.documents.isEmpty){return Center(child: Text("We don't have any item yet."));}
                return ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 20),
                  padding: EdgeInsets.all(20),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, idx) {
                    DocumentSnapshot item = snapshot.data.documents[idx];
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.pushNamed(context, "/itemDetail", arguments: item.reference.documentID);
                      },
                      child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.network(item["images"][0], width: 80, height: 80, fit: BoxFit.cover,),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(item["name"], style: Theme.of(context).textTheme.headline6.merge(TextStyle(height: .95)),),
                            SizedBox(height: 10),
                            StarRatingWidget(
                              rating: item["rating"], 
                              fillColor: Theme.of(context).primaryColor,
                              mainAxisAlignment: MainAxisAlignment.start,
                            ),
                            Text("\$${item["price"]}", style: Theme.of(context).textTheme.headline6,),
                          ],
                        ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                        IconButton(
                          iconSize: 32,
                          icon: Icon(
                            wishlist != null && wishlist.isNotEmpty && wishlist.contains(item.reference.path) ? Icons.favorite : Icons.favorite_border, 
                            color: Colors.pink, 
                          ), 
                        onPressed: () => addToWishlist(item)),

                cart != null && cart.where((element) => element["path"] == item.reference.path).isEmpty ?
                        IconButton(
                          iconSize: 32,
                          icon: Icon(
                            Icons.add_shopping_cart, 
                            color: Theme.of(context).primaryColor, 
                          ), 
                        onPressed: () => addItemToCart(item)) :
                        Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          iconSize: 32,
                          icon: Icon(
                                    Icons.remove_circle, 
                                    color: Theme.of(context).accentColor,
                                  ), onPressed: () => removeItem(item)),
                        SizedBox(width: 5),
                        Text(cart == null ? "" : "${cart.where((element) => element["path"] == item.reference.path).first["count"]}", style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.center,),
                        SizedBox(width: 5),
                        IconButton(
                          iconSize: 32,
                          icon: Icon(
                          Icons.add_circle, 
                          color: Theme.of(context).accentColor,
                        ), onPressed: () => addItem(item)),
                      ],
                    )
                          ],
                        )
                        
                      ],
                    ));
                });
              }
            )
      );
  }
}
