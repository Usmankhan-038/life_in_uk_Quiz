import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';

class ProgressPage extends StatefulWidget {
  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  late int quickTestaAverageScore = 0;
  late int quicktest = 0;
  late int mocktest = 0;
  late int mockTestAverageScore = 0;

  var currentUser = FirebaseAuth.instance.currentUser;

  int selected = 1;

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
          fixedColor: Color.fromRGBO(149, 186, 237, 0.467),
          unselectedItemColor: Colors.white,
          currentIndex: selected,
          onTap: ontappeditem,
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Progress'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('userProgress')
              .doc(currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              quickTestaAverageScore = snapshot.data!.get('quickAveragescore');
              quicktest = snapshot.data!.get('quickTestTaken');
              mocktest = snapshot.data!.get('Mocktesttaken');
              mockTestAverageScore = snapshot.data!.get('mockAverageScore');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Lottie.asset('assets/animation_lktxrmr3.json'),
                ),
              );
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Quick Test",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 70,
                                backgroundColor: Color.alphaBlend(
                                    Color.fromARGB(255, 224, 26, 12),
                                    Color.fromARGB(255, 255, 64, 0)),
                                child: Text(
                                  '${quicktest.round()}',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 20),
                                child: Text('Test taken'),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 70,
                                backgroundColor: Color.alphaBlend(
                                    Color.fromARGB(93, 224, 26, 12),
                                    Color.fromARGB(255, 215, 179, 167)),
                                child: Text(
                                  '${quickTestaAverageScore.round()}%',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 20),
                                child: Text('Average Score'),
                              ),
                            ],
                          ),
                        ]),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Center(
                      child: Text(
                        "Mock Test",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                  Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 70,
                                backgroundColor: Color.alphaBlend(
                                    Color.fromARGB(255, 224, 26, 12),
                                    Color.fromARGB(255, 255, 64, 0)),
                                child: Text(
                                  '${mocktest.round()}',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 20),
                                child: Text('Test taken'),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 70,
                                backgroundColor: Color.alphaBlend(
                                    Color.fromARGB(93, 224, 26, 12),
                                    Color.fromARGB(255, 215, 179, 167)),
                                child: Text(
                                  '${mockTestAverageScore.round()}%',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 20),
                                child: Text('Average Score'),
                              ),
                            ],
                          ),
                        ]),
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: adContainer,
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
