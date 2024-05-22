import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/percent_indicator.dart';
import './SideBarPage.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

// import 'package:admob_flutter/admob_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  late var progressValue = 0;
  late var progressMockValue = 0;
  late var progressquickValue = 0;
  final int accuracy = 0;
  bool paddingFlag = true;
  int selected = 0;
  void initState() {
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

  void onTapItem(int index) {
    setState(() {
      selected = index;
    });
    if (selected > 2) {
      selected = 0;
    }
    if (index == 0) {
      const ZoomPageTransitionsBuilder();
      Navigator.of(context).pushNamed('/homePage');
    } else if (index == 1) {
      const ZoomPageTransitionsBuilder();
      Navigator.of(context).pushNamed('/progress');
    } else if (index == 2) {
      Navigator.of(context).pushNamed('/ProgressKey');
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/LoginPage', (Route<dynamic> route) => false);
    const ZoomPageTransitionsBuilder();
  }

  Future<void> _onRefreshHandler() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('userProgress')
        .doc(currentUser!.uid)
        .get();
    setState(() {
      progressquickValue = snapshot.get('quickAveragescore');
      progressMockValue = snapshot.get('mockAverageScore');
      progressValue = ((progressMockValue + progressquickValue) / 2).toInt();
    });
    return await Future.delayed(Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc(currentUser!.uid)
          .snapshots(),
      builder: (ctx, index) {
        final currentUser = FirebaseAuth.instance.currentUser;
        return Scaffold(
          drawer: SideBar(),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
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
            onTap: onTapItem,
          ),
          appBar: AppBar(
            backgroundColor: Colors.white,
            actions: [
              TextButton(
                onPressed: _logout,
                child: Text(
                  'LogOut',
                  style: TextStyle(color: Color.fromRGBO(24, 23, 22, 1)),
                ),
              ),
            ],
          ),
          body: LiquidPullToRefresh(
            onRefresh: _onRefreshHandler,
            color: Colors.blue,
            backgroundColor: Colors.blue[200],
            showChildOpacityTransition: false,
            height: 120,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('userProgress')
                    .doc(currentUser!.uid)
                    .snapshots(),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData)
                    progressquickValue =
                        snapshot.data!.get('quickAveragescore');
                  progressMockValue = snapshot.data!.get('mockAverageScore');
                  progressValue =
                      ((progressMockValue + progressquickValue) / 2).toInt();
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Lottie.asset('assets/animation_lktxrmr3.json'),
                      ),
                    );
                  // Image.network('https://unsplash.com/photos/ufnZ3kJwgSo');

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedTextKit(
                        isRepeatingAnimation: false,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Life in the \n United kingdom',
                            speed: const Duration(milliseconds: 70),
                            textStyle: TextStyle(
                                color: Colors.red,
                                fontSize: 35,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30, bottom: 5),
                        child: Center(
                            child: CircularPercentIndicator(
                          animation: true,
                          radius: 50,
                          lineWidth: 10,
                          progressColor: progressValue > 50
                              ? progressValue < 80
                                  ? Color.fromARGB(255, 10, 111, 194)
                                  : Colors.green
                              : Colors.red,
                          backgroundColor: progressValue > 50
                              ? progressValue < 80
                                  ? Color.fromARGB(255, 151, 196, 217)
                                  : Color.fromARGB(255, 174, 239, 176)
                              : Color.fromARGB(255, 234, 154, 148),
                          circularStrokeCap: CircularStrokeCap.round,
                          percent: progressValue / 100,
                          center: Text(
                            '${progressValue.round()}%',
                            style: TextStyle(fontSize: 25),
                          ),
                        )),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 5),
                        child: Center(
                          child: Text(
                              'Keep Practicing your progress will be show here',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        constraints: BoxConstraints(
                            maxWidth: double.infinity, minHeight: 400),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed('/studyMaterial');
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(5, 20, 5, 20),
                                height: 210,
                                color: Colors.red,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.menu_book,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Study',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25),
                                              ),
                                              Text(
                                                '${progressquickValue.round()}% Progress',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      alignment: AlignmentDirectional.topEnd,
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushNamed('/studyMaterial');
                                        },
                                        icon: Icon(
                                          Icons.arrow_right,
                                          size: 60,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed('/startQuiz');
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(5, 20, 5, 20),
                                // width: double.tryParse('380'),
                                height: 210,
                                color: Colors.blue,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.speed,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Pratice',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25),
                                              ),
                                              Text(
                                                '${progressMockValue.round()}% Progress',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      alignment: AlignmentDirectional.topEnd,
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushNamed('/startQuiz');
                                        },
                                        icon: Icon(
                                          Icons.arrow_right,
                                          size: 60,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
