import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Question extends StatelessWidget {
  var Questiontext;
  Question(this.Questiontext);
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      child: Text(
        Questiontext,
        style: TextStyle(fontSize: 28),
        textAlign: TextAlign.center,
      ),
    );
  }
}
