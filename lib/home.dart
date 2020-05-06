import 'package:flutter/material.dart';
import 'package:plant_store/carousel.dart';
import 'package:plant_store/rating.dart';

class HomePage extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.menu, color: Colors.white), onPressed: null),
            title: Text("Plant Store"),
            actions: [
              IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: null)
            ]),
        body: SingleChildScrollView(
            child: Column(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
                child: Text("Featured",
                    style: TextStyle(
                        fontSize: 28.0, fontWeight: FontWeight.bold))),
            CarouselWidget(data: carousel)
          ]),
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
                      setState(() {
                        Navigator.pushNamed(context, "/profile");
                      });
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
