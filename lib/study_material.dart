import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';

import 'Quiz/QuizPage.dart';

class StudyMaterial extends StatefulWidget {
  const StudyMaterial({super.key});

  @override
  State<StudyMaterial> createState() => _StudyMaterialState();
}

class _StudyMaterialState extends State<StudyMaterial> {
  var selected = 0;
  bool Britishflag = false;
  bool flag = false;
  bool geographyflag = false;
  bool societyandvalueflag = false;
  bool UkEconomyflag = false;
  bool britishGovermentflag = false;
  late BannerAd myBanner;
  var TestName = [];
  var TestFlag = [];
  var TestScore = [];
  int index = 0;

  void initState() {
    myBanner = BannerAd(
      adUnitId: 'ca-app-pub-5938529581480852/3875768157',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(),
    );
    myBanner.load();
    super.initState();

    FirebaseFirestore.instance
        .collection('system setup data')
        .doc('TestName')
        .get()
        .then((snapshot) {
      setState(() {
        TestName = List<String>.from(snapshot.data()!['Tests'] ?? []);
        TestFlag = List<String>.from(snapshot.data()!['TestFlag'] ?? []);
        TestScore = List<String>.from(snapshot.data()!['QuickTestScore'] ?? []);
      });
    });
    UpdateUserProgress();
    updateUserData();
  }

  Future<void> UpdateUserProgress() async {
    var user = FirebaseAuth.instance.currentUser;
    var userProgressDoc =
        FirebaseFirestore.instance.collection('userProgress').doc(user?.uid);

    var userProgressSnapshot = await userProgressDoc.get();
    if (userProgressSnapshot.exists) {
      userProgressDoc.update({
        'index': 0,
      });
    }
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

  Future<void> showResultDialog(
      BuildContext context, String name, String Flag, String Score) async {
    var user = FirebaseAuth.instance.currentUser;
    var userProgressDoc =
        FirebaseFirestore.instance.collection('userProgress').doc(user?.uid);
    var userProgressSnapshot = await userProgressDoc.get();

    if (userProgressSnapshot.exists) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Note'),
            content: Text(
                'You need to Score 8 Points out of 10 Points in 10 min to Pass the Test\n\nClick On \"OK\" to Start Test'),
            actions: [
              TextButton(
                onPressed: () {
                  BritishTest(name, Flag, Score);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void BritishTest(String test, String flag, String testScoreName) {
    print(test);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => QuickTestPage(
        testName: test,
        flagName: flag,
        TestScore: testScoreName,
      ),
    ));
  }

  void ontappeditem(int index) {
    setState(() {
      selected = index;
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
    final AdWidget adWidget = AdWidget(ad: myBanner);
    final Container adContainer = Container(
      child: adWidget,
      height: myBanner.size.height.toDouble(),
      width: myBanner.size.width.toDouble(),
    );
    final currentUser = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('userProgress')
          .doc(currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
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
              ),
            ],
            backgroundColor: Color.fromRGBO(24, 23, 22, 1),
            fixedColor: Colors.white,
            unselectedItemColor: Colors.white,
            currentIndex: selected,
            onTap: ontappeditem,
          ),
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(244, 67, 54, 1),
            title: Text(
              'Study Card',
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushNamed('/homePage');
              },
            ),
          ),
          body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('userProgress')
                  .doc(currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Lottie.asset('assets/animation_lktxrmr3.json'),
                    ),
                  );
                }
                return Container(
                  margin: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              for (int i = 0; i < TestName.length; i++)
                                GestureDetector(
                                  onTap: () {
                                    if (i < TestName.length &&
                                        i < TestFlag.length) {
                                      showResultDialog(context, TestName[i],
                                          TestFlag[i], TestScore[i]);
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(left: 3, right: 3),
                                    alignment: Alignment.centerLeft,
                                    width: double.infinity,
                                    margin: EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: Border.all(
                                        color:
                                            Color.fromARGB(255, 213, 219, 230),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 5,
                                        bottom: 5,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                TestName[i] ?? '',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    child:
                                                        snapshot.data!.get(
                                                                TestFlag[i])
                                                            ? Text(
                                                                snapshot.data!.get(
                                                                            TestScore[i]) <
                                                                        8
                                                                    ? 'Try Again'
                                                                    : 'Pass',
                                                                style: TextStyle(
                                                                    color: snapshot.data!.get(TestScore[i]) <
                                                                            8
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .green,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            : Text(
                                                                'Not Attempt',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      '  Score ${snapshot.data!.get(TestScore[i])}/10',
                                                      style: TextStyle(
                                                          color: snapshot.data!.get(
                                                                      TestScore[
                                                                          i]) <
                                                                  8
                                                              ? Colors.red
                                                              : Colors.green),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          snapshot.data!.get(TestFlag[i])
                                              ? snapshot.data!
                                                          .get(TestScore[i]) <
                                                      8
                                                  ? Icon(
                                                      Icons.cancel,
                                                      color: Colors.red,
                                                    )
                                                  : Icon(Icons.check,
                                                      color: Colors.green)
                                              : SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: adContainer,
                        ),
                      ),
                    ],
                  ),
                );
              }),
        );
      },
    );
  }
}
