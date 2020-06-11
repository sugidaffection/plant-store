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
    });
  }

  void removeFromWishlist(DocumentSnapshot item){
    setState(() {
      if(wishlist.contains(item.documentID))
        wishlistRef.document(item.documentID).delete();
    });
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
                return Row(
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
                        
                        IconButton(
                          icon: Icon(
                            Icons.favorite, 
                            color: Colors.pink, 
                            size: 32,
                          ), 
                        onPressed: () => removeFromWishlist(item))
                      ],
                    );
              }, separatorBuilder: (context, idx) => SizedBox(height: 20), itemCount: items.length, padding: EdgeInsets.all(20),);
            }
          }
          return Center(child: CircularProgressIndicator());
        }
      )
    );
  }
}