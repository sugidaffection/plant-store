import 'dart:async';

import 'package:flutter/material.dart';

class Carousel {
  final String title, subtitle;
  final ImageProvider image;

  Carousel({this.title: "", this.subtitle: "", this.image});
}

class CarouselWidget extends StatefulWidget {
  final List<Carousel> data;
  final double height;
  final int selected;
  final bool timer;

  CarouselWidget(
      {Key key, @required this.data, this.selected = 0, this.height = 300, this.timer = true})
      : super(key: key);

  @override
  _CarouselWidgetState createState() =>
      _CarouselWidgetState(data, height, selected);
}

class _CarouselWidgetState extends State<CarouselWidget> {
  List<Carousel> data;
  double height;
  int selected = 0;
  Timer timer;

  _CarouselWidgetState(this.data, this.height, this.selected);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.timer)
      startTimer();
  }

  void startTimer(){
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      setState(() {
        selected = (selected + 1) % data.length;

      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(widget.timer) {
    timer.cancel();
    timer = null;
    }
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        onHorizontalDragEnd: (detail) {
          if (detail.velocity.pixelsPerSecond.dx > 0) {
            setState(() {
              selected = (selected - 1) % data.length;
              if(widget.timer){
              timer.cancel();
              startTimer();
              }
            });
          } else if (detail.velocity.pixelsPerSecond.dx < 0) {
            setState(() {
              selected = (selected + 1) % data.length;
              if(widget.timer){
              timer.cancel();
              startTimer();
              }
            });
          }
        },
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
          AnimatedSwitcher(
            duration: Duration(seconds: 1),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: Container(
                key: ValueKey(selected),
                height: 250,
                child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      Image(
                          image: data[selected].image,
                          fit: BoxFit.fitWidth,
                          colorBlendMode: BlendMode.darken,
                          color: Colors.black38),
                      Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            Text(data[selected].title,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline4),
                            Text(
                              data[selected].subtitle,
                              style: Theme.of(context).primaryTextTheme.bodyText2,
                            )
                          ])),
                    ])),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: 
          Wrap(
            spacing: 10,
            children: List.generate(data.length, (index) {
              return AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.easeInToLinear,
                  height: 12,
                  width: selected == index ? 24 : 12,
                  decoration: BoxDecoration(
                    color: selected == index ? Theme.of(context).accentColor : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(43)
                  ),
                );
            }),
          ))
        ]));
  }
}
