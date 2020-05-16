import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_store/model/item.dart';
import 'package:plant_store/view/rating.dart';

class ItemCard extends StatelessWidget {

  final DocumentSnapshot item;

  const ItemCard({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 6.0
          )
        ]
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: 5,
        children: [
          StreamBuilder(
              stream: item.reference.collection("images").snapshots(),
              builder: (context, snapshot){
              if(snapshot.hasData){
                if(snapshot.data.documents.length > 0){ 
                  return ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    child: Image.network(
                    snapshot.data.documents[0]["url"],
                    loadingBuilder: (context, child, loadingProgress) {
                      if(loadingProgress == null){
                        return child;
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                    
                    height: 130,
                    width: double.infinity,
                    
                    fit: BoxFit.cover,
                  ));
                }
              }
              return Center(child: Icon(Icons.image));

          }),
          SizedBox(height: 10),
          Text(item["name"], style: Theme.of(context).textTheme.headline6),
          StarRatingWidget(rating: double.parse(item["rating"]), fillColor: Theme.of(context).primaryColor),
          Text("\$${item["price"]}", style: Theme.of(context).textTheme.headline5.merge(TextStyle(color: Colors.black54)))
        ],
      ),
    );
  }
}