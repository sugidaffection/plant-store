import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plantstore/view/rating.dart';

class ItemCard extends StatelessWidget {

  final DocumentSnapshot item;

  const ItemCard({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
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
          ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Image.network(
                item["images"][0],
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                alignment: Alignment.center,
            )),
          SizedBox(height: 10),
          Text(item.data["name"], textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6),
          StarRatingWidget(rating: item["rating"], fillColor: Theme.of(context).primaryColor),
          Text("\$${item["price"]}", style: Theme.of(context).textTheme.headline6.merge(TextStyle(color: Colors.black54)))
        ],
      ),
    );
  }
}