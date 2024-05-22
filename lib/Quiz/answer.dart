import 'package:flutter/material.dart';

class Answers extends StatefulWidget {
  final Function selectHandler;
  final String ansText;
  final bool showNextButton;
  final int score;

  Answers(this.selectHandler, this.ansText, this.showNextButton, this.score);

  @override
  _AnswersState createState() => _AnswersState();
}

class _AnswersState extends State<Answers> {
  Color buttonColor = Color.fromARGB(242, 212, 214, 215);

  void updateButtonColor() {
    print("Score ${widget.score}");

    widget.selectHandler();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: ElevatedButton(
          onPressed: widget.showNextButton ? null : () => updateButtonColor(),
          style: ElevatedButton.styleFrom(
            primary: buttonColor,
            onSurface: widget.score == 1 ? Colors.green : Colors.red,
            onPrimary: Colors.black,
          ),
          child: Text(
            widget.ansText,
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
