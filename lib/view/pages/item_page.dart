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
  
  @override
  Widget build(BuildContext context) {
    final Object args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(args.toString()),
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
                        
                        IconButton(
                          icon: Icon(
                            wishlist != null && wishlist.isNotEmpty && wishlist.contains(item.reference.path) ? Icons.favorite : Icons.favorite_border, 
                            color: Colors.pink, 
                            size: 32,
                          ), 
                        onPressed: () => addToWishlist(item))
                      ],
                    ));
                });
              }
            )
      );
  }
}
