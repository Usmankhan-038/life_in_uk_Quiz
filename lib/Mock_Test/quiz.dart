import 'package:flutter/material.dart';
import './question.dart';
import './answer.dart';

class Quiz extends StatelessWidget {
  final List<Map<String, dynamic>> questions;
  final int index;
  final Function answerQuestion;
  final bool showNextButton;

  Quiz(
    this.questions,
    this.index,
    this.answerQuestion,
    this.showNextButton,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Question(questions[index]['question']),
        ...(questions[index]['answer'] as List<Map<String, dynamic>>)
            .map((answer) {
          return Answers(
            () => answerQuestion(answer['score']),
            answer['text'],
            showNextButton,
            answer['score'],
          );
        }).toList(),
      ],
    );
  }
}
