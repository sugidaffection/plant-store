import 'package:flutter/material.dart';

class StarRatingWidget extends StatelessWidget {

  final double rating, size;
  final MainAxisAlignment mainAxisAlignment;
  final Color fillColor, unfillColor;

  StarRatingWidget({Key key, this.rating = .0, this.fillColor = Colors.lightBlue, this.unfillColor = Colors.grey, this.size = 16, this.mainAxisAlignment = MainAxisAlignment.center}) : super(key: key);

  List<Widget> buildStar() {
    final List<Widget> star = [];

    for(int i = 1; i <= 5; i++) {
      star.add(Icon(Icons.star, color: rating >= i ? this.fillColor : this.unfillColor, size: this.size,));
    }

    return star;
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: buildStar());
  }
}