import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController searchController = new TextEditingController();
  bool showClearBtn = false;
  FocusNode _focusNode = new FocusNode();
  bool isFocused = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          focusNode: _focusNode,
            controller: searchController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration.collapsed(
              border: InputBorder.none,
              hintText: "Search item",
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
      body: StreamBuilder(
        stream: Firestore.instance.collection("items").snapshots(),
        builder: (context, snapshot){
        if (snapshot.hasData) {
          if(snapshot.data.documents.isEmpty) return Center(child: Text("Sorry. We don't have any item yet."),);
          if(searchController.text.trim().isEmpty && isFocused) return createList(snapshot.data.documents);
          if(searchController.text.trim().isEmpty) return Center(child: Text("Search item"));
          var data = snapshot.data.documents.where((doc) => doc["name"].toString().toLowerCase().contains(searchController.text.trim().toLowerCase()) ).toList();
          if(data.length > 0) {
            return createList(data);
          }
          return Center(child: Text("No items match"),);
        }
        return Center(child: CircularProgressIndicator());
      }),
    );
  }

  ListView createList(data) {
    return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 16),
        itemCount: data.length,
        itemBuilder: (context, i){
          return ListTile(
            title: Text(data[i]["name"], style: Theme.of(context).textTheme.headline6,),
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
              backgroundImage: NetworkImage(data[i]["images"][0]),
            )]),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: (){},
          );
      });
  }
}