import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockResult extends StatefulWidget {
  final int lastResult;
  final int totalNumberQuestion;
  final Function resetBtn;
  final Uid;
  const MockResult(
      this.lastResult, this.resetBtn, this.totalNumberQuestion, this.Uid);
  @override
  State<MockResult> createState() => _ResultState();
}

void updateData(int numOftest, int average, int question) {
  var Uid;
  Uid = FirebaseAuth.instance.currentUser;
  FirebaseFirestore.instance.collection('userProgress').doc(Uid.uid).update({
    'Mocktesttaken': ++numOftest,
    'mockAverageScore': ((average * 100) / question).round()
  });
}

class _ResultState extends State<MockResult> {
  bool dataUpdated = false;

  @override
  void initState() {
    super.initState();
    if (!dataUpdated) {
      FirebaseFirestore.instance
          .collection('userProgress')
          .doc(widget.Uid.uid)
          .get()
          .then((snapshot) {
        int testTaken = snapshot.get('Mocktesttaken');
        updateData(testTaken.round(), widget.lastResult.round(),
            widget.totalNumberQuestion.round());
        setState(() {
          dataUpdated = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    int percentage = widget.totalNumberQuestion == 0
        ? 0
        : ((widget.lastResult * 100) / widget.totalNumberQuestion).round();
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('userProgress')
            .doc(widget.Uid.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data!;
          int mockAverageScore = data.get('mockAverageScore');
          int testTaken = data.get('Mocktesttaken');

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.lightBlue,
                  child: Center(
                    child: Text(
                      '$mockAverageScore%',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Test Taken: $testTaken',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Mock Average Score: $mockAverageScore%',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
