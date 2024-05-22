import 'package:flutter/material.dart';
import 'package:life_in_uk/splashscreen.dart';
import 'package:life_in_uk/start_mock_test_quiz.dart';
import 'Mock_Test/QuizPage.dart';
import 'Quiz/QuickTestPage.dart';
import 'package:life_in_uk/study_material.dart';
import './Term_and_Condition.dart';
import './contact_us.dart';
import './Progress_Key.dart';
import 'homePage.dart';
import './User_Authentication/user_auth_page.dart';
import 'start_Quiz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './Quiz/Progress.dart';
import './User_Authentication/ForgetPassword.dart';
import './user_account.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();
  final PageController Controller = PageController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(primarySwatch: Colors.grey, brightness: Brightness.light),
      home: SplashScreen(),
      routes: {
        '/login': (_) => StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  Image.asset('lib/Images/life in the uk Logo.png');
                }
                if (userSnapshot.hasData) {
                  return MyHomePage();
                }
                return UserAuthPage();
              },
            ),
        '/homePage': (_) => MyHomePage(),
        // '/mockTest': (_) => MockTest(),
        '/studyMaterial': (_) => StudyMaterial(),
        '/startQuiz': (_) => StartQuiz(),
        '/QuickTest': (_) => QuickTest(
              testScore: '',
            ),
        // '/UKeconomy': (_) => UkEconomyTest(),
        // '/UKgeography': (_) => UkGeographyTest(),
        // '/UKSocietyandValue': (_) => UkSocietyAndValueTest(),
        // '/BritishGoverment': (_) => BritishGovermentTest(),
        '/progress': (_) => ProgressPage(),
        '/LoginPage': (_) => UserAuthPage(),
        '/forgetPassword': (_) => ForgetPassword(),
        '/contactUs': (_) => ContactUs(),
        '/termandcondition': (_) => TermAndCondition(),
        '/ProgressKey': (_) => ProgressKey(),
        '/UserAccount': (_) => UserAccount(),
        '/mockTest1': (_) => MockTestPage(),
        '/mockTestMaterial': (_) => MockTestMaterial()
      },
    );
  }
}
