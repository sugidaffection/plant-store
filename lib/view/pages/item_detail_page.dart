import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantstore/view/carousel.dart';
import 'package:plantstore/view/rating.dart';

class ItemDetailPage extends StatefulWidget {
  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {

  DocumentSnapshot doc;
  DocumentReference docRef;

  CollectionReference wishlistRef;
  List<String> wishlist = [];

  CollectionReference cartRef;
  List<Map<String, dynamic>> cart;
  Map<String, dynamic> cartItem;
  
  FirebaseUser user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseAuth.instance.currentUser().then((value){
      setState(() {
        user = value;
      });

      wishlistRef = Firestore.instance.collection("user").document(user.uid).collection("wishlist").reference();
      wishlistRef.snapshots().listen((event) {
        if(this.mounted)
          setState(() {
            wishlist = event.documents.map((e) => e.reference.documentID).toList();
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
      if(wishlist != null && wishlist.isNotEmpty && wishlist.contains(item.documentID))
        wishlistRef.document(item.documentID).delete();
      else
        wishlistRef.document(item.documentID).setData({
          "ref" : item.reference
        });
    });
  }

  void addItem() {
    if(this.mounted)
    setState(() {
      if(cartItem != null)
        cartItem["ref"].updateData({
          "count": cartItem["count"] + 1
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

  void removeItem() {
    if(this.mounted)
      setState(() {
        if(cartItem != null)
          if(cartItem["count"] - 1 > 0)
            cartItem["ref"].updateData({
              "count": cartItem["count"] - 1
            });
          else cartItem["ref"].delete();
      });
  }

  @override
  Widget build(BuildContext context) {
    final Object docID = ModalRoute.of(context).settings.arguments;
    
    docRef = Firestore.instance.collection("items").document(docID);
    docRef.snapshots().listen((event) {
      doc = event;
    });

    if(cart != null && cart.where((element) => element["path"] == doc.reference.path).isNotEmpty)
      cartItem = cart.where((element) => element["path"] == doc.reference.path).first;

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              wishlist != null && wishlist.isNotEmpty && wishlist.contains(doc.documentID) ? Icons.favorite : Icons.favorite_border, 
              color: Colors.pinkAccent, 
              size: 32,
            ), 
          onPressed: () => addToWishlist(doc))
        ],
      ),
      body: doc == null ? Center(child: CircularProgressIndicator(),) : 
      
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselWidget(data: 
              List.generate(doc["images"].length, (index) {
                return Carousel(image: NetworkImage(doc["images"][index]));
              })
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20), 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  Text(doc["name"], style: Theme.of(context).textTheme.headline5.merge(TextStyle(fontWeight: FontWeight.bold))),
                  StarRatingWidget(rating: doc["rating"], fillColor: Theme.of(context).primaryColor, mainAxisAlignment: MainAxisAlignment.start,),
                  Text("\$${doc["price"]}", style: Theme.of(context).textTheme.headline5.merge(TextStyle(fontWeight: FontWeight.bold)), textAlign: TextAlign.right,),
                  SizedBox(height: 10),
                  Text(doc["detail"], style: Theme.of(context).textTheme.bodyText1,),
                ])
              )
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: cart.where((element) => element["path"] == doc.reference.path).isEmpty ?
              RaisedButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                    onPressed: () => addItemToCart(doc),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add_shopping_cart),
                        SizedBox(width: 10),
                        Text("Add to cart")
                      ],
                    )
                  ) :
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  iconSize: 42,
                  icon: Icon(
                            Icons.remove_circle, 
                            color: Theme.of(context).accentColor,
                          ), onPressed: () => removeItem()),
                SizedBox(width: 10),
                Text("${cart.where((element) => element["path"] == doc.reference.path).first["count"]}", style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.center,),
                SizedBox(width: 10),
                IconButton(
                  iconSize: 42,
                  icon: Icon(
                  Icons.add_circle, 
                  color: Theme.of(context).accentColor,
                ), onPressed: () => addItem()),
                Spacer(),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryTextTheme.button.color,
                  onPressed: (){
                  Navigator.of(context).pushNamed("/cart");
                }, child: Text("Payment"))
              ],
            )
        )])
      )
    ;
  }
}