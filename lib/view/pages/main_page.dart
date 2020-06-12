import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantstore/view/card.dart';
import 'package:plantstore/view/carousel.dart';
import 'package:plantstore/view/rating.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Carousel> carousel = [
    Carousel(title: "Mom's Day", subtitle: "Give beautiful plant for your mom", image: 
        AssetImage("assets/images/mothers_day.jpg")),
    Carousel(title: "Mom's Day", subtitle: "Give s plant for your mom", image:
        AssetImage("assets/images/snake_plant.jpg")),
    Carousel(title: "Mom's Day", subtitle: "Give beautiful d for your mom", image:
        AssetImage("assets/images/mothers_day.jpg")),
  ];

  FirebaseUser user;
  List<DocumentSnapshot> cart;

  List<DocumentSnapshot> items;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseAuth.instance.currentUser()
      .then((value) {
        user = value;
        Firestore.instance.collection("user").document(user.uid).collection("cart").snapshots().listen((event) {
          if(this.mounted)
            setState(() {
              cart = event.documents;
            });
          else cart = List();
        });

        Firestore.instance.collection("items").snapshots().listen((event) {
          if(this.mounted)
            setState(() {
              items = event.documents;
            });
          else items = List();
        });
      });
      
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void logout() async{
    FirebaseAuth.instance.signOut();
  }

  Widget createCardList(name, List<DocumentSnapshot> docs) {
    if(docs == null) return Center(child: CircularProgressIndicator());
    if (docs.isEmpty) return Center(child: Text("We don't have any item yet."));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
            SizedBox(height: 20),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(children: [
                  Text(name,
                      style: Theme.of(context).textTheme.headline5),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/items", arguments: name);
                    },
                    child: Text("See More",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor)),
                  )
                ])),
            Container(
                height: 280,
                width: double.infinity,
                child: ListView(
                  padding: EdgeInsets.all(10),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: [
                    Wrap(
                      spacing: 15,
                      children: List.generate(4, (index){
                        return GestureDetector(child: ItemCard(item: docs[index]),
                        onTap: () {
                          if(docs != null && docs.isNotEmpty)
                            Navigator.pushNamed(context, "/itemDetail", arguments: docs[index].reference.documentID);
                        },);
                  }))
                  ],
                ))]);
  }

  void addToCart(DocumentSnapshot item) {
    Iterable<DocumentSnapshot> data = cart.where((element) => element.data["ref"].path == item.reference.path);
    setState(() {
      if (data.isEmpty)
        Firestore
        .instance
        .collection("user")
        .document(user.uid)
        .collection("cart")
        .document(item.documentID).setData(
          {
            "ref": item.reference,
            "count": 1
          }
        );
      else if (data.first != null) {
        data.first.reference.updateData({
          "count" : data.first.data["count"] + 1
        });
      }
    });                                 
  }

  void removeFromCart(item) {
    Iterable<DocumentSnapshot> data = cart.where((element) => element.data["ref"].path == item.reference.path);
    if (data.isNotEmpty)
      setState(() {
        if (data.first.data["count"] - 1 == 0){
          data.first.reference.delete();
        }else {
          data.first.reference.updateData({
            "count" : (data.first.data["count"] - 1) > 0 ? data.first.data["count"] - 1 : 0
          });
        }
        
      });
  }

  Widget createGridView(List<DocumentSnapshot> documents) {
    return GridView.count(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 150 / 250,
            shrinkWrap: true,
          crossAxisCount: 2,
          children: documents.map<Widget>(
            (item){
              var cartItemFilter = cart == null ? Iterable.empty() : cart.where((element) => element["ref"]
                              .path == item.reference.path);
              var cartItem = cartItemFilter.isNotEmpty ? cartItemFilter.first : null;
              var cartItemCount = cartItem != null ? cartItem.data["count"] : 0;


        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.pushNamed(context, "/itemDetail", arguments: item.reference.documentID);
          },
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 120,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:NetworkImage(item["images"][0],), 
                    fit: BoxFit.cover,),
            )),
              Text(item["name"], style: Theme.of(context).textTheme.headline6),
              Row(
              children: [
                StarRatingWidget(
                rating: item["rating"],
                fillColor: Theme.of(context).primaryColor,
                mainAxisAlignment: MainAxisAlignment.start,),
                Spacer(),
                Text("\$${item["price"]}", style: Theme.of(context).textTheme.subtitle1),
              ],),
              
              Spacer(),
              cartItem != null && cartItemCount > 0 ? 
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.remove_circle, color: Theme.of(context).accentColor,), 
                    onPressed: () => removeFromCart(item),
                    iconSize: 42
                  ),
                  Text("$cartItemCount",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle, color: Theme.of(context).accentColor,), 
                    onPressed: () => addToCart(item),
                    iconSize: 42
                  ),
                ],
              ) :
              Container(
                child: 
                RaisedButton(
                  onPressed: () => addToCart(item), 
                  child: 
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Icon(Icons.add_shopping_cart),
                    SizedBox(width: 10,),
                    Text("Add to cart"),
                  ]),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                ))
            ]
        
        ));
      }
    ).toList(),
                         
                  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
          CarouselWidget(data: carousel),
          createCardList("Popular", items),
          StreamBuilder(
            stream: Firestore.instance.collection("items").snapshots(),
            builder: (context, snapshot){
              if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
              if (snapshot.data.documents.isEmpty) return Container();
              Set<String> categories = Set();
              snapshot.data.documents.forEach((doc) => doc["category"].forEach(
                (category){
                  categories.add(category);
                }
              )
              );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    SizedBox(height: 20),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(children: [
                          Text("Category",
                              style: Theme.of(context).textTheme.headline5),
                        ])),
                    Container(
                        height: 70,
                        width: double.infinity,
                        child: ListView(
                                padding: EdgeInsets.all(10),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                children: [
                                  Wrap(
                                    spacing: 15,
                                    children: List.generate(categories.length, (index){
                                       return GestureDetector(
                                         onTap: () {
                                           Navigator.pushNamed(context, "/items", arguments: categories.toList()[index]);
                                         },
                                         child: Container(
                                          width: 150,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: Colors.red.shade300
                                          ),
                                          child: Center(child: Text(categories.toList()[index], style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)
                                          ),),
                                        ));
                                }))
                                ],
                        ))
                    ]);
                  }),
                      
          createCardList("Recommended", items != null ? items.reversed.toList() : items),

          items == null ? CircularProgressIndicator() :
          items.isEmpty ? Center(child: Text("Empty Item")) :
          Column(
            crossAxisAlignment: 
              CrossAxisAlignment.start, 
                  children: [
                      SizedBox(height: 20),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(children: [
                            Text("Explore",
                                style: Theme.of(context).textTheme.headline5),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/items", arguments: "Explore");
                              },
                              child: Text("See More",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor)),
                            )
                          ])),
                        createGridView(items)
            ]
          )


        ])));
  }
}
