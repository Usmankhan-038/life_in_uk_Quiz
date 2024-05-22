import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TermAndCondition extends StatelessWidget {
  const TermAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    double lineHeight = 7;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text('Term and Contion'),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Color.fromARGB(255, 233, 230, 230)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
              margin: EdgeInsets.only(left: 5, right: 5, top: 10),
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Term and Condition',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                width: double.infinity,
                height: 600,
                padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
                margin: EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'By using this app you agree to these terms.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(
                        height: lineHeight,
                      ),
                      Text(
                        'Article 1. Limited Liability',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      SizedBox(
                        height: lineHeight,
                      ),
                      Text(
                        'Thie App is providing without warranty of any kind, or claim to correctness. App may change at any time without prior notice to you. You will nothold the App developer responsible forloss of data.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(
                        height: lineHeight,
                      ),
                      Text(
                        'Article 2. Personal Data',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      SizedBox(
                        height: lineHeight,
                      ),
                      Text(
                        'The privacy satement contains information on how the app processes personal data. By accepting these term you give consent that your personal will be processed in that way. When your are below age of 16 years the consent be given by the person who has parental responsiblity over you.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(
                        height: lineHeight,
                      ),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
