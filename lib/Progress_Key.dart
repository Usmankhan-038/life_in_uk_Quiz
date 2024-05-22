import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ProgressKey extends StatefulWidget {
  @override
  State<ProgressKey> createState() => _ProgressKeyState();
}

class _ProgressKeyState extends State<ProgressKey> {
  int selected = 2;
  var videoURL = 'https://www.youtube.com/watch?v=ysNtOmZyqCY&t=4s';
  var SecondUrl = "https://www.youtube.com/watch?v=ysNtOmZyqCY&t=4s";
  late YoutubePlayerController _controller;
  late YoutubePlayerController _secondcontroller;
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
  void initState() {
    final VideoID = YoutubePlayer.convertUrlToId(videoURL);
    final SecondVideoID = YoutubePlayer.convertUrlToId(SecondUrl);

    if (VideoID != null) {
      _controller = YoutubePlayerController(
        initialVideoId: VideoID,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
        ),
      );
    }
    if (SecondVideoID != null) {
      _secondcontroller = YoutubePlayerController(
        initialVideoId: SecondVideoID,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
        ),
      );
    }

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
        title: Text('Product Key'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Color.fromARGB(255, 236, 235, 235),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/life-in-uk-c9e3b.appspot.com/o/Life%20in%20Uk%2FLifeInUK.jfif?alt=media&token=6204fc73-3051-4574-a57a-d35c505581e4'),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "For Further information ",
                          style: TextStyle(
                              color: Color.fromARGB(222, 0, 0, 0),
                              fontSize: 15),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        child: GestureDetector(
                          child: Text(
                            'Click Here',
                            style: TextStyle(color: Colors.blue, fontSize: 15),
                          ),
                          onTap: () async {
                            var url =
                                "https://lifeintheuktests.co.uk/life-in-the-uk-test/";
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw "Cannot load URl";
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 250,
              width: double.infinity,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    onReady: () => debugPrint('Ready'),
                    bottomActions: [
                      CurrentPosition(),
                      ProgressBar(
                        isExpanded: true,
                        colors: ProgressBarColors(
                          playedColor: Colors.red,
                          handleColor: Colors.red[200],
                        ),
                      ),
                      PlaybackSpeedButton(),
                      PlayPauseButton(),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      "Life in the UK test (2023)",
                      style: TextStyle(fontSize: 17),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 250,
              width: double.infinity,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  YoutubePlayer(
                    controller: _secondcontroller,
                    showVideoProgressIndicator: true,
                    onReady: () => debugPrint('Ready'),
                    bottomActions: [
                      CurrentPosition(),
                      ProgressBar(
                        isExpanded: true,
                        colors: ProgressBarColors(
                          playedColor: Colors.red,
                          handleColor: Colors.red[200],
                        ),
                      ),
                      PlaybackSpeedButton(),
                      PlayPauseButton(),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      "Life in the UK test (2023)",
                      style: TextStyle(fontSize: 17),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
