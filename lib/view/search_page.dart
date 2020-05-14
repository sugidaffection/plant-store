import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController searchController = new TextEditingController();
  bool showClearBtn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
            controller: searchController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration.collapsed(
              border: InputBorder.none,
              hintText: "Search your item",
              hintStyle: TextStyle(
                color: Colors.white
              ),
            ),
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none
            ),
            enableSuggestions: false,
            autocorrect: false,
            maxLines: 1,
            onChanged: (value) {
              setState((){
                showClearBtn = value.isNotEmpty;
              });
              
            },
        ),
        actions: showClearBtn ? [
          IconButton(icon: Icon(Icons.close, color: Colors.white), onPressed: (){
            setState(() {
              searchController.clear();
              showClearBtn = false;
            });
            FocusScope.of(context).unfocus();

          })
        ] : [],
      ),
      body: Container(),
    );
  }
}