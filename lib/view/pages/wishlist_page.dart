import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantstore/view/rating.dart';

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore db = Firestore.instance;

  FirebaseUser user;

  List<String> wishlist = [];
  CollectionReference wishlistRef;

  CollectionReference cartRef;

  List<Map<String, dynamic>> cart;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth.currentUser().then((value){
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

  void removeFromWishlist(DocumentSnapshot item){
    setState(() {
      if(wishlist.contains(item.documentID))
        wishlistRef.document(item.documentID).delete();
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Wishlist"),
      ),
      body: user == null ? Center(child: CircularProgressIndicator()) : 
        wishlist.isEmpty ? Center(child: Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text("Wishlist is empty", style: Theme.of(context).textTheme.headline5,),
                Text("Explore more and save some items"),
                SizedBox(height: 20),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: (){
                    Navigator.pushNamed(context, "/items", arguments: "Explore");
                  },
                  child: Text("Explore Items", style: Theme.of(context).primaryTextTheme.button,),
                )
              ]
            )) :  StreamBuilder(
        stream: db.collection("items").where(FieldPath.documentId, whereIn: wishlist).snapshots(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            if(snapshot.data.documents.isNotEmpty){
              List<DocumentSnapshot> items = snapshot.data.documents;
              return ListView.separated(itemBuilder: (context, idx){
                DocumentSnapshot item = items[idx];
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
                          icon: Icon(
                            Icons.favorite, 
                            color: Colors.pink, 
                            size: 32,
                          ), 
                        onPressed: () => removeFromWishlist(item)),

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
              }, separatorBuilder: (context, idx) => SizedBox(height: 20), itemCount: items.length, padding: EdgeInsets.all(20),);
            }
          }
          return Center(child: CircularProgressIndicator());
        }
      )
    );
  }
}