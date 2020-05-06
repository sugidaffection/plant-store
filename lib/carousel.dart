import 'package:flutter/material.dart';

class Carousel {
  final String title, subtitle;
  final ImageProvider image;

  Carousel(this.title, this.subtitle, this.image);
}

class CarouselWidget extends StatefulWidget {

  final List<Carousel> data;
  final double height;
  final int selected;

  CarouselWidget({Key key, @required this.data, this.selected = 0, this.height = 300}) : super(key: key);

  @override
  _CarouselWidgetState createState() => _CarouselWidgetState(data, height, selected);
}

class _CarouselWidgetState extends State<CarouselWidget> {

  List<Carousel> data;
  double height;
  int selected;

  _CarouselWidgetState(this.data, this.height, this.selected);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (detail){
        print(selected);
        if(detail.velocity.pixelsPerSecond.dx > 0){
          setState(() {
            selected -= selected > 0 ? 1 : 0;
          });
        }else if(detail.velocity.pixelsPerSecond.dx < 0) {
          setState(() {
            selected += selected < data.length - 1 ? 1 : 0;
          });
        }
      },
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: data[selected].image, 
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black12, BlendMode.darken)
          )
        ),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(data[selected].title, style: TextStyle(fontSize: 32, color: Colors.white)),
                  Text(data[selected].subtitle, style: TextStyle(fontSize: 18, color: Colors.white)),
                ],
              )
            ),
            Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
              child: Wrap(
                direction: Axis.horizontal,
                spacing: 10,
                children: List.generate(data.length, (i){
                  return Container(
                    width: selected == i ? 20 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: selected == i ? Colors.lightBlue : Colors.grey,
                      borderRadius: BorderRadius.circular(50)
                    ),
                  );
                })
              )
            )
          ]
        ),
      )
    );
  }
}
