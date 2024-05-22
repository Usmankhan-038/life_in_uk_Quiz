import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class StartQuiz extends StatefulWidget {
  const StartQuiz({super.key});

  @override
  State<StartQuiz> createState() => _StartQuizState();
}

class _StartQuizState extends State<StartQuiz> {
  int selected = 2;

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

  late BannerAd myBanner;
  void initState() {
    myBanner = BannerAd(
      adUnitId: 'ca-app-pub-5938529581480852/3875768157',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(),
    );
    myBanner.load();
    updateUserData();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final AdWidget adWidget = AdWidget(ad: myBanner);
    final Container adContainer = Container(
      child: adWidget,
      height: myBanner.size.height.toDouble(),
      width: myBanner.size.width.toDouble(),
    );
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
        backgroundColor: Color.fromARGB(244, 0, 140, 255),
        title: Text(
          'Quiz',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/homePage');
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: adContainer,
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.all(10),
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 213, 219, 230)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 25),
                                child: Center(
                                  child: Text(
                                    'Mock Test',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 20, left: 10, right: 10),
                                child: Center(
                                  child: Text(
                                    "Want to ace the life in the UK test? Take our mock test and boost your confidence.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 107, 185, 222),
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "START",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed('/mockTestMaterial');
                                },
                              )
                            ],
                          )
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Color.fromARGB(255, 213, 219, 230)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 25),
                              child: Center(
                                child: Text(
                                  'Quick Test',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(top: 20, left: 20, right: 20),
                              child: Center(
                                child: Text(
                                  "Are you ready for the life in the UK test? Try our quick test and find out.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 107, 185, 222),
                                  // border: Border.all(
                                  //     color: Color.fromARGB(255, 213, 219, 230)),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20)),
                                ),
                                child: Center(
                                  child: Text(
                                    "START",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed('/studyMaterial');
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
