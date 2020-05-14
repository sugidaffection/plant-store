import 'package:flutter/material.dart';
import 'package:plant_store/model/item.dart';
import 'package:plant_store/view/rating.dart';

class ItemCard extends StatelessWidget {

  final Item item;

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
            color: Colors.black12,
            blurRadius: 6.0
          )
        ]
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: 5,
        children: [
          item.image,
          SizedBox(height: 10),
          Text(item.name, style: Theme.of(context).textTheme.headline6),
          StarRatingWidget(rating: 4, fillColor: Theme.of(context).primaryColor),
          Text("\$${item.price}", style: Theme.of(context).textTheme.headline5.merge(TextStyle(color: Colors.black54)))
        ],
      ),
    );
  }
}