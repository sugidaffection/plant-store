import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_store/view/card.dart';

class ItemPage extends StatefulWidget {
  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  
  @override
  Widget build(BuildContext context) {
    final Object args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(args.toString()),
        ),
        body:StreamBuilder(
              stream: Firestore.instance.collection("products").snapshots(),
              builder: (context, snapshot) {
                if(!snapshot.hasData){return Center(child: CircularProgressIndicator());}
                if(snapshot.data.documents.isEmpty){return Center(child: Text("Empty Item"));}
                return GridView.count(
                  childAspectRatio: 200/260,
                  scrollDirection: Axis.vertical,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  crossAxisCount: 2, 
                  padding: EdgeInsets.all(10),
                  children: List.generate(snapshot.data.documents.length, (index){
                    return ItemCard(item: snapshot.data.documents[index]);
                  }));
              }
            )
            
      );
  }
}
