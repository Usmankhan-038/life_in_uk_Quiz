import 'package:flutter/material.dart';

class StudyPageButton extends StatelessWidget {
  final buttonName;
  final Color color;
  final Function selectedHandler;
  const StudyPageButton(this.buttonName, this.color, this.selectedHandler);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 30,
      margin: EdgeInsets.all(4),
      color: Colors.blue,
      child: ElevatedButton(
        child: Text('${buttonName}', textAlign: TextAlign.start),
        onPressed: () {
          selectedHandler();
        },
        style: ElevatedButton.styleFrom(backgroundColor: color),
      ),
    );
  }
}
