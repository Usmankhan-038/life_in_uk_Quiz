// import 'package:flutter/material.dart';
// import 'package:slide_countdown/slide_countdown.dart';

// class QuizTimer extends StatefulWidget {
//   final VoidCallback
//       onTimerUp; // Callback function to notify when the timer is up

//   QuizTimer({required this.onTimerUp});

//   @override
//   _QuizTimerState createState() => _QuizTimerState();
// }

// class _QuizTimerState extends State<QuizTimer> {
//   // int remainingTime = 300;
//   // bool isQuizOver = false;
//   // void startTimer() {
//   //   Timer.periodic(Duration(seconds: 1), (timer) {
//   //     setState(() {
//   //       if (remainingTime > 0) {
//   //         remainingTime--;
//   //       } else {
//   //         timer.cancel();
//   //         isQuizOver = true;
//   //       }
//   //     });
//   //   });
//   // }

//   // void initState() {
//   //   super.initState();
//   //   startTimer();
//   // }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         margin: EdgeInsets.only(
//           top: 10,
//           right: 10,
//         ),
//         child: Align(
//           alignment: Alignment.centerRight,
//           child: SlideCountdown(
//             key: GlobalKey(),
//             duration: Duration(minutes: 5),
//             onDone: widget
//                 .onTimerUp, // Call the callback function when the timer is up
//             padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//             decoration: BoxDecoration(
//                 color: Colors.red
//                     .withOpacity(0.6)), // Set a semi-transparent red color
//           ),
//         ),
//       ),
//     );
//   }
// }
