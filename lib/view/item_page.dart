import 'package:flutter/material.dart';

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
        body: Padding(
            padding: EdgeInsets.all(20),
            child: ListView(children: [Container(child: Text("Item"))])));
  }
}
