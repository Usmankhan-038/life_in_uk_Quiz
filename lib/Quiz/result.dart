import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class result extends StatefulWidget {
  final int lastResult;
  final int totalNumberQuestion;
  final Function resetBtn;
  final Function resultflags;
  final Uid;
  const result(this.lastResult, this.resetBtn, this.totalNumberQuestion,
      this.Uid, this.resultflags);
  @override
  State<result> createState() => _resultState();
}

void updateData(int numOftest, int average, int question, int dataAverage) {
  var Uid;
  Uid = FirebaseAuth.instance.currentUser;
  FirebaseFirestore.instance.collection('userProgress').doc(Uid.uid).update({
    'quickTestTaken': ++numOftest,
    'quickAveragescore': dataAverage > 100
        ? 100
        : (((average * 100) / question) * 0.2 + dataAverage).toInt(),
  });
}

class _resultState extends State<result> {
  bool dataUpdated = false;
  void initState() {
    super.initState();
    if (!dataUpdated) {
      FirebaseFirestore.instance
          .collection('userProgress')
          .doc(widget.Uid.uid)
          .get()
          .then((snapshot) {
        int testTaken = snapshot.get('quickTestTaken');
        int average = snapshot.get('quickAveragescore');
        updateData(testTaken.round(), widget.lastResult.round(),
            widget.totalNumberQuestion.round(), average.round());
        dataUpdated = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('userProgress')
              .doc(widget.Uid.uid)
              .snapshots(),
          builder: (context, snapshot) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.lightBlue,
                      child: Center(
                          child: Text(
                        '${((widget.lastResult * 100) / widget.totalNumberQuestion).round()}%',
                        style: TextStyle(fontSize: 30),
                      )),
                    ),
                  ),
                  widget.resultflags() ?? const SizedBox(),
                ],
              ),
            );
          }),
    );
  }
}
