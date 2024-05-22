import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'quiz.dart'; // Make sure you import the correct path to your quiz.dart file

// ignore: must_be_immutable
class QuickTest extends StatefulWidget {
  final String testName;
  final testFlag;
  bool isTimerUp;
  int totalScore;
  int index;
  final VoidCallback? resetButton;
  final Function? onTestFinished;
  String TestScore;

  QuickTest({
    this.testName = 'British History',
    this.testFlag = 'BritishHistory',
    this.isTimerUp = false,
    this.totalScore = 0,
    this.index = 0,
    this.resetButton,
    this.onTestFinished,
    this.TestScore = '',
    required String testScore,
  });

  @override
  State<QuickTest> createState() => QuickTestState();

  Future<void> showResultDialog(BuildContext context) async {
    var user = FirebaseAuth.instance.currentUser;
    var userProgressDoc =
        FirebaseFirestore.instance.collection('userProgress').doc(user?.uid);
    var userProgressSnapshot = await userProgressDoc.get();

    if (userProgressSnapshot.exists) {
      int score = userProgressSnapshot.get('totalScore');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Quiz Result'),
            content: Text('Your total score is: $score'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/studyMaterial');
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> UpdateUserProgress() async {
    var user = FirebaseAuth.instance.currentUser;
    var userProgressDoc =
        FirebaseFirestore.instance.collection('userProgress').doc(user?.uid);

    var userProgressSnapshot = await userProgressDoc.get();
    if (userProgressSnapshot.exists) {
      int testTaken = userProgressSnapshot.get('Mocktesttaken');
      int score = userProgressSnapshot.get('totalScore');
      userProgressDoc.update({
        'quickTestTaken': testTaken + 1,
        'quickAveragescore': ((score * 100) / 24).round(),
        'index': ++index,
        'timer': false,
      });
    }
    FirebaseFirestore.instance
        .collection('userProgress')
        .doc(user!.uid)
        .update({
      testFlag: true,
    });
  }
}

class QuickTestState extends State<QuickTest> {
  List<Map<String, dynamic>> _questionList = [];
  final currentUserUid = FirebaseAuth.instance.currentUser;
  bool showNextButton = false;
  int count = Random().nextInt(20) + 1;
  bool updateResult = false;

  void backButton() {
    setState(() {
      Navigator.of(context).pushNamed('/studyMaterial');
    });
  }

  void nextQuestion(int itemCount) {
    setState(() {
      widget.index++;
      count = Random().nextInt(20) + 1;
      showNextButton = false;
    });
  }

  void answerQuestion(int score) {
    widget.totalScore += score;
    if (widget.totalScore != 0) updateScore();
    setState(() {
      showNextButton = true;
    });
  }

  void resetButton() {
    Navigator.of(context).pushNamed('/');
  }

  int selected = 1;
  void onTappedItem(int index) {
    setState(() {
      selected = index;
      updateResult = true;
    });
    if (index == 0) {
      Navigator.of(context).pushNamed('/homePage');
    } else if (index == 1) {
      Navigator.of(context).pushNamed('/progress');
    } else if (index == 2) {
      Navigator.of(context).pushNamed('/ProgressKey');
    }
  }

  void initState() {
    super.initState();
    if (widget.isTimerUp || widget.index == 10) {
      widget.UpdateUserProgress();
    }
  }

  Future<void> updateScore() async {
    var user = FirebaseAuth.instance.currentUser;
    var userProgressDoc =
        FirebaseFirestore.instance.collection('userProgress').doc(user?.uid);
    var userProgressSnapshot = await userProgressDoc.get();
    if (userProgressSnapshot.exists) {
      userProgressDoc.update({'totalScore': widget.totalScore});
      userProgressDoc.update({widget.TestScore: widget.totalScore});
    } else {
      userProgressDoc.set({'totalScore': widget.totalScore});
      userProgressDoc.set({widget.TestScore: widget.totalScore});
    }
  }

  onTestFinished() {
    FirebaseFirestore.instance
        .collection('userProgress')
        .doc(currentUserUid!.uid)
        .update({
      widget.testFlag: true,
      'timer': true,
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection(widget.testName).snapshots(),
        builder: (ctx, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: Lottie.asset('assets/animation_lktxrmr3.json'),
              ),
            );
          }

          if (streamSnapshot.hasError) {
            print('Error retrieving data: ${streamSnapshot.error}');
          }

          final documents = streamSnapshot.data?.docs;
          _questionList.clear();
          for (var document in documents!) {
            try {
              // Get the question and answers from the document
              final question = document['text'];
              final ans1 = document['ans1'];
              final ans2 = document['ans2'];
              final ans3 = document['ans3'];
              final correctAnswer = document['correctanswer'];

              // Format the data and add it to _questionvar
              _questionList.add({
                'question': question,
                'answer': [
                  {'text': ans1, 'score': ans1 == correctAnswer ? 1 : 0},
                  {'text': ans2, 'score': ans2 == correctAnswer ? 1 : 0},
                  {'text': ans3, 'score': ans3 == correctAnswer ? 1 : 0}
                ]
              });
            } catch (e) {
              print('Error retrieving data: $e');
            }
          }
          print(_questionList.length);
          return widget.index <= documents.length - 1 &&
                  widget.index < 10 &&
                  !widget.isTimerUp
              ? Column(
                  children: [
                    Quiz(_questionList, count, answerQuestion, showNextButton),
                    Visibility(
                      visible: showNextButton,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () {
                          nextQuestion(documents.length);
                        },
                        child: Text(
                          'Next',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: FutureBuilder(
                    future: widget.UpdateUserProgress(),
                    builder:
                        (BuildContext context, AsyncSnapshot<void> snapshot) {
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200,
                            child: widget.totalScore == 8
                                ? Lottie.asset("assets/animation_lkzh3v5w.json")
                                : Lottie.asset(
                                    "assets/animation_lkzs9784.json"),
                          ),
                          Center(
                            child: widget.totalScore == 8
                                ? Text(
                                    "Congratulation! You have \nPassed the Test",
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 25),
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    "Sorry! Try Again",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 25),
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              widget.showResultDialog(context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                            child: Text(
                              'Show Points',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ); // Widget sliverBox is not defined in the code snippet
        },
      ),
    );
  }
}
