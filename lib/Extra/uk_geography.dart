import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../Quiz/quiz.dart';
import '../Quiz/result.dart';

class UkGeographyTest extends StatefulWidget {
  const UkGeographyTest({Key? key});

  @override
  State<UkGeographyTest> createState() => _UkGeographyTestState();
}

class _UkGeographyTestState extends State<UkGeographyTest> {
  List<Map<String, dynamic>> _questionvar = [];
  final currentUserUid = FirebaseAuth.instance.currentUser;
  bool showNextButton = false;
  int index = 0;
  int count = Random().nextInt(55);
  int totalscore = 0;
  int timerLeft = 120;
  bool updateresult = false;

  void backButton() {
    setState(() {
      Navigator.of(context).pushNamed('/studyMaterial');
    });
  }

  void NextQuestion(int countItem) {
    setState(() {
      index++;
      count = Random().nextInt(countItem);
      showNextButton = false;
    });
  }

  onTestFinished() {
    FirebaseFirestore.instance
        .collection('userProgress')
        .doc(currentUserUid!.uid)
        .update({
      'GeographyFlag': true,
    });
    return;
  }

  void _answerQuestion(int score) {
    totalscore += score;

    setState(() {
      showNextButton = true;
    });

    print(totalscore);
  }

  void resetButton() {
    Navigator.of(context).pushNamed('/');
  }

  int selected = 1;
  void ontappeditem(int index) {
    setState(() {
      selected = index;
      updateresult = true;
    });
    if (index == 0) {
      Navigator.of(context).pushNamed('/homePage');
    } else if (index == 1) {
      Navigator.of(context).pushNamed('/progress');
    } else if (index == 2) {
      Navigator.of(context).pushNamed('/ProgressKey');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: 'Progress',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_sharp),
            label: 'Key Progress',
            backgroundColor: Colors.white,
          )
        ],
        backgroundColor: Color.fromRGBO(24, 23, 22, 1),
        fixedColor: Colors.white,
        unselectedItemColor: Colors.white,
        currentIndex: selected,
        onTap: ontappeditem,
      ),
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Center(
          child: index < 10
              ? Text('Question ${index + 1}/10',
                  style: TextStyle(color: Colors.white))
              : Text('Rseult', style: TextStyle(color: Colors.white)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => backButton(),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Center(
                // child: Text(
                //   '${timerLeft}',
                //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                //   textAlign: TextAlign.right,
                // ),
                ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('UK Geography').snapshots(),
        builder: (ctx, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final documents = streamSnapshot.data?.docs;
          _questionvar.clear();
          for (var document in documents!) {
            // Get the question and answers from the document
            final question = document['text'];
            final ans1 = document['ans1'];
            final ans2 = document['ans2'];
            final ans3 = document['ans3'];
            final correctAnswer = document['correctanswer'];

            // Format the data and add it to _questionvar
            // final formattedAnswers = ;
            _questionvar.add({
              'question': question,
              'answer': [
                {'text': ans1, 'score': ans1 == correctAnswer ? 1 : 0},
                {'text': ans2, 'score': ans2 == correctAnswer ? 1 : 0},
                {'text': ans3, 'score': ans3 == correctAnswer ? 1 : 0}
              ]
            });
          }

          print(_questionvar.length);
          return index <= documents.length - 1 && index < 10
              ? Column(
                  children: [
                    Quiz(_questionvar, count, _answerQuestion, showNextButton),
                    Visibility(
                      visible: showNextButton,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        onPressed: () {
                          NextQuestion(documents.length);
                        },
                        child: Text('Next'),
                      ),
                    ),
                  ],
                )
              : !updateresult
                  ? result(totalscore, resetButton, index, currentUserUid,
                      onTestFinished)
                  : widget.sliverBox;
        },
      ),
    );
  }
}
