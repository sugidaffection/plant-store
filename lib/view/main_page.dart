import 'package:flutter/material.dart';
import 'package:plant_store/model/item.dart';
import 'package:plant_store/view/card.dart';
import 'package:plant_store/view/carousel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  List<Item> items = [
    Item(
      image: Image(image: AssetImage("assets/images/snake_plant.jpg")),
      name: "Snake Plant",
      desc: "indoor plant for air puryfing",
      price: 55.0
    ),
    Item(
      image: Image(image: AssetImage("assets/images/snake_plant.jpg")),
      name: "Snake Plant",
      desc: "indoor plant for air puryfing",
      price: 55.0
    ),
    Item(
      image: Image(image: AssetImage("assets/images/snake_plant.jpg")),
      name: "Snake Plant",
      desc: "indoor plant for air puryfing",
      price: 55.0
    ),
    Item(
      image: Image(image: AssetImage("assets/images/snake_plant.jpg")),
      name: "Snake Plant",
      desc: "indoor plant for air puryfing",
      price: 55.0
    ),
    Item(
      image: Image(image: AssetImage("assets/images/snake_plant.jpg")),
      name: "Snake Plant",
      desc: "indoor plant for air puryfing",
      price: 55.0
    ),
    Item(
      image: Image(image: AssetImage("assets/images/snake_plant.jpg")),
      name: "Snake Plant",
      desc: "indoor plant for air puryfing",
      price: 55.0
    ),
    Item(
      image: Image(image: AssetImage("assets/images/snake_plant.jpg")),
      name: "Snake Plant",
      desc: "indoor plant for air puryfing",
      price: 55.0
    )
  ];

  List<Carousel> carousel = [
    Carousel("Mom's Day", "Give beautiful plant for your mom",
        AssetImage("assets/images/mothers_day.jpg")),
    Carousel("Mom's Day", "Give s plant for your mom",
        AssetImage("assets/images/snake_plant.jpg")),
    Carousel("Mom's Day", "Give beautiful d for your mom",
        AssetImage("assets/images/mothers_day.jpg")),
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
              onPressed: () => Navigator.of(context).pushNamed("/search")
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
            SizedBox(height: 20),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(children: [
                  Text("Popular",
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold)),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/items", arguments: "Popular");
                      print("asd");
                    },
                    child: Text("See More",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor)),
                  )
                ])),
            Container(
                height: 300,
                width: double.infinity,
                child: ListView(
                  padding: EdgeInsets.all(10),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: [
                    Wrap(
                      spacing: 15,
                      children: List.generate(items.length, (index){
                    return ItemCard(item: items[index]);
                  }))
                  ],
                ))
          ])
        ])));
  }
}
