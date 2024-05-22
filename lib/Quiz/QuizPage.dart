// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:slide_countdown/slide_countdown.dart';

import 'QuickTestPage.dart';

class QuickTestPage extends StatefulWidget {
  final String testName;
  final String flagName;
  final String TestScore;
  const QuickTestPage({
    this.testName = "",
    this.flagName = "",
    this.TestScore = "",
  });

  @override
  State<QuickTestPage> createState() => QuickTestPageState();
}

class QuickTestPageState extends State<QuickTestPage> {
  int selected = 1;
  bool updateResult = false;
  int index = 0;
  int totalScore = 0;
  bool isTimerUp = false;
  Function onTestFinish = () {};
  late BannerAd myBanner;
  late Timer userProgressTimer;
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

  void resetButton() {
    Navigator.of(context).pushNamed('/homePage');
  }

  void backButton() {
    setState(() {
      Navigator.of(context).pushNamed('/startQuiz');
    });
  }

  Future<void> UpdateUserProgress() async {
    var user = FirebaseAuth.instance.currentUser;
    var userProgressDoc =
        FirebaseFirestore.instance.collection('userProgress').doc(user?.uid);

    var userProgressSnapshot = await userProgressDoc.get();
    if (userProgressSnapshot.exists) {
      index = userProgressSnapshot.get('index');
    }
    print("index${index}");
    if (index > 10) {
      isTimerUp = true;
    }
  }

  void initState() {
    myBanner = BannerAd(
      adUnitId: 'ca-app-pub-5938529581480852/3875768157',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(),
    );
    myBanner.load();

    super.initState();
    updateUserData();
  }

  void updateUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userProgressRef = FirebaseFirestore.instance
        .collection('userProgress')
        .doc(currentUser!.uid);
    final userProgressSnapshot = await userProgressRef.get();
    final userProgressData = userProgressSnapshot.data()!;

    final snapshot = await FirebaseFirestore.instance
        .collection('system setup data')
        .doc('TestName')
        .get();
    final testFlag = List<String>.from(snapshot.data()!['TestFlag'] ?? []);
    final mockFlag = List<String>.from(snapshot.data()!['MockTestFlag'] ?? []);
    final mockTestScore =
        List<String>.from(snapshot.data()!['MockTestScore'] ?? []);
    final QuickTestScore =
        List<String>.from(snapshot.data()!['QuickTestScore'] ?? []);

// Check for missing flags and update user's progress data
    for (String flag in testFlag) {
      if (!userProgressData.containsKey(flag)) {
        await userProgressRef.update({flag: false});
      }
    }

    for (String flag in mockFlag) {
      if (!userProgressData.containsKey(flag)) {
        await userProgressRef.update({flag: false});
      }
    }
    for (String Score in mockTestScore) {
      if (!userProgressData.containsKey(Score)) {
        await userProgressRef.update({Score: 0});
      }
    }
    for (String Score in QuickTestScore) {
      if (!userProgressData.containsKey(Score)) {
        await userProgressRef.update({Score: 0});
      }
    }
  }

  void dispose() {
    // Cancel the timer when the widget is disposed
    if (isTimerUp) userProgressTimer.cancel();
    super.dispose();
  }
  // ignore: non_constant_identifier_names

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final AdWidget adWidget = AdWidget(ad: myBanner);
    final Container adContainer = Container(
      child: adWidget,
      height: myBanner.size.height.toDouble(),
      width: myBanner.size.width.toDouble(),
    );
    UpdateUserProgress();
    // late User currentUserUid = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_sharp),
            label: 'Key Progress',
          )
        ],
        backgroundColor: Color.fromRGBO(24, 23, 22, 1),
        fixedColor: Colors.white,
        unselectedItemColor: Colors.white,
        currentIndex: selected,
        onTap: onTappedItem,
      ),
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Center(
            child: index < 10 && !isTimerUp
                ? Text('Quick Test', style: TextStyle(color: Colors.white))
                : Text('Result', style: TextStyle(color: Colors.white))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: backButton,
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Center(),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 50,
            child: !isTimerUp && index < 10
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text('Time Remaining',
                            style: TextStyle(fontSize: 18)),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, right: 10),
                        child: SlideCountdown(
                          key: GlobalKey(),
                          duration: Duration(minutes: 10),
                          onDone: () {
                            setState(() {
                              if (index >= 10)
                                isTimerUp = true;
                              else
                                isTimerUp = true;
                              print("index ${index}");
                            });
                          },
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox(height: 1),
          ),
          Expanded(
            child: QuickTest(
              testName: widget.testName,
              testFlag: widget.flagName,
              isTimerUp: isTimerUp,
              totalScore: totalScore,
              index: index,
              resetButton: resetButton,
              onTestFinished: onTestFinish,
              TestScore: widget.TestScore,
              testScore: '',
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: adContainer,
            ),
          ),
        ],
      ),
    );
  }
}
