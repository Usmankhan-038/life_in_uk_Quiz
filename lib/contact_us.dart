import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  final String email = 'fk514955@gmail.com';
  final String subject = 'Question from the app';
  final String body = 'Hello,\n\nI have a question regarding...';

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      throw 'Could not launch email';
    }
  }

  void initState() {
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text('Contact us'),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 233, 230, 230),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 5, right: 5, top: 10),
              decoration: BoxDecoration(color: Colors.blue),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Contact Us',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                  Icon(
                    Icons.email,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Life_In_UK.com',
                    style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Text(
                    '+92309 9715231',
                    style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Text(
                    'fk514955@gmail.com',
                    style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(color: Colors.white),
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(50),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return Container(
                        margin: EdgeInsets.all(10),
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Column(children: [
                            IconButton(
                              onPressed: () {
                                _launchEmail();
                              },
                              icon: Icon(
                                Icons.email_outlined,
                                size: 45,
                              ),
                            ),
                            Center(
                              child: Text(
                                'Email',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ]),
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text(
                  'Ask a Question',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
