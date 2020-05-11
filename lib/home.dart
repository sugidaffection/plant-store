import 'dart:async';

import 'package:flutter/material.dart';
import 'package:plant_store/carousel.dart';
import 'package:plant_store/rating.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  List<Map<String, String>> itemImage = [
    {
      "image": "assets/images/snake_plant.jpg",
      "name": "Snake Plant",
      "price": "20"
    }
  ];

  List<Carousel> carousel = [
    Carousel("Mom's Day", "Give beautiful plant for your mom",
        AssetImage("assets/images/mothers_day.jpg")),
    Carousel("Mom's Day", "Give s plant for your mom",
        AssetImage("assets/images/snake_plant.jpg")),
    Carousel("Mom's Day", "Give beautiful d for your mom",
        AssetImage("assets/images/snake_plant.jpg")),
  ];

  void logout() async{
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();

    Navigator.of(context).pushReplacementNamed("/");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Plant Store"), actions: [
          IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: logout
              )
        ]),
        drawer: Drawer(
          child: Padding(padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              Center(
                child: Column(
                  children: [
                    Text("Sugiono", style: Theme.of(context).textTheme.headline),
                    Text("1772037@maranatha.ac.id", style: Theme.of(context).textTheme.subhead),
                  ]
                ),
              ),
              SizedBox(height: 40),
              OutlineButton(onPressed: logout, child: Text("Logout"))
            ],
            
          )
          )
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          CarouselWidget(data: carousel),
         
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding: EdgeInsets.all(10),
                child: Row(children: [
                  Text("Popular",
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold)),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/items", arguments: SearchArguments("Popular"));
                      print("asd");
                    },
                    child: Text("See More",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.blue)),
                  )
                ])),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 250,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: [],
                ))
          ])
        ])));
  }
}

class SearchArguments {
  final String search;

  SearchArguments(this.search);
}