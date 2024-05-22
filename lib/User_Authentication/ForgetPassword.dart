import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  var userEmail = "";
  var sentEmailFlag = false;
  var sentEmail = false;

  void forgetPassword(String email, BuildContext ctx) {
    FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .catchError((onError) {
      setState(() {
        if (email.isEmpty ||
            // ignore: unnecessary_null_comparison
            email == null ||
            !email.contains('@') ||
            !email.contains('.com')) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(
              content: Text("Please Enter Valid Email"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        } else
          sentEmailFlag = true;
      });
    }).then((value) {
      setState(() {
        if (email.isEmpty ||
            // ignore: unnecessary_null_comparison
            email == null ||
            !email.contains('@') ||
            !email.contains('.com')) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(
              content: Text("Please Enter Valid Email"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        } else {
          sentEmailFlag = true;
          sentEmail = true;
        }
      });
    });
  }

  void SentEmail() {
    // FirebaseAuth.instance.sent
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Password Reset',
            style: TextStyle(color: Colors.black26),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            margin: EdgeInsets.only(bottom: 25),
            child: Text(
              'Please enter your email address to sent the password resent link',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            child: TextFormField(
              key: ValueKey('Email'),
              decoration: InputDecoration(
                label: Text('Email'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.email),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains('@')) {
                  return 'Please Enter valid Email';
                }
                return null;
              },
              onChanged: (value) => userEmail = value,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          if (sentEmailFlag)
            Container(
              margin: EdgeInsetsDirectional.symmetric(horizontal: 10),
              child: sentEmail
                  ? Text(
                      'Successfully sent Email',
                      style: TextStyle(color: Colors.green),
                    )
                  : Text(
                      'Network Error in sending Email',
                      style: TextStyle(color: Colors.red),
                    ),
            ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text('Sent', style: TextStyle(color: Colors.white)),
              onPressed: () {
                forgetPassword(userEmail, context);
              },
            ),
          )
        ],
      ),
    );
  }
}
