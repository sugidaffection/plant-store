import 'package:flutter/material.dart';
import 'package:plant_store/home.dart';

class ItemPage extends StatefulWidget {


  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {

  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final SearchArguments searchArguments = ModalRoute.of(context).settings.arguments;

    search.text = searchArguments.search;

    return Scaffold(
      appBar: AppBar(
        title: Text(search.text),
      ),
      body: Padding(padding: EdgeInsets.all(20), child: Column(
        children: [
          TextField(
            controller: search,
            decoration: InputDecoration(
              hintText: "Search"
            ),
          ),
          SizedBox(height: 20),
         Expanded(
          //  height: 100,
           child:  ListView(
            children: [
              Container(
                child: Text("Item")
              )
            ]
          )
         )
        ]
      ))
    );
  }
}
