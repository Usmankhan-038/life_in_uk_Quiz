import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../user_image_picker.dart';
import 'package:lottie/lottie.dart';

class UserAuthPage extends StatefulWidget {
  @override
  State<UserAuthPage> createState() => _UserAuthPageState();
}

class _UserAuthPageState extends State<UserAuthPage> {
  var userName = '';
  var userEmail = '';
  var userPass = '';
  var password = '';
  var confirmpassword = '';
  bool login = false;
  bool flagSignin = true;
  var isLoading = false;
  File? userImage;
  var obscuretext = true;
  var confirmobscuretext = true;
  var sentEmail = false;
  var userImageFlag = false;
  var testFlag = [];

  void userPickImage(File image) {
    userImage = image;
    userImageFlag = true;
  }

  void forgetPassword() {
    Navigator.of(context).pushNamed('/forgetPassword');
  }

  String getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    String initials = "";
    int numWords = 2;
    if (nameSplit.length < numWords) {
      numWords = nameSplit.length;
    }
    for (var i = 0; i < numWords; i++) {
      initials += nameSplit[i][0];
    }
    return initials;
  }

  void submitUserData(String email, String userName, String password, bool flag,
      BuildContext ctx) async {
    var authResult;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
            content: flag
                ? Text(
                    "Please enter all required fields",
                    textAlign: TextAlign.center,
                  )
                : Text(
                    "Image is Optional",
                    textAlign: TextAlign.center,
                  ),
            backgroundColor: Colors.blue),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      if (flag) {
        // Login
        authResult = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        // Fetch current user's progress data
        final currentUser = FirebaseAuth.instance.currentUser;
        final userProgressRef = FirebaseFirestore.instance
            .collection('userProgress')
            .doc(currentUser!.uid);
        final userProgressSnapshot = await userProgressRef.get();
        final userProgressData = userProgressSnapshot.data()!;

        // Fetch TestFlag data
        final snapshot = await FirebaseFirestore.instance
            .collection('system setup data')
            .doc('TestName')
            .get();
        final testFlag = List<String>.from(snapshot.data()!['TestFlag'] ?? []);
        final mockFlag =
            List<String>.from(snapshot.data()!['MockTestFlag'] ?? []);
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
      } else {
        // Sign up
        if (password != confirmpassword) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
                content: Text("Password and Confirm Password do not match"),
                backgroundColor: Colors.red),
          );
          setState(() {
            isLoading = false;
          });
          return;
        }

        authResult = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        if (!flagSignin && userImage != null) {
          final Reference ref = FirebaseStorage.instance
              .ref()
              .child('User_Image')
              .child(authResult.user!.uid + '.jpg');

          await ref.putFile(userImage!);

          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user!.uid)
              .set({
            'username': userName,
            'email': userEmail,
            'uid': authResult.user!.uid,
            'image_url': await ref.getDownloadURL(),
          });
        } else {
          DocumentSnapshot systemSetupDoc = await FirebaseFirestore.instance
              .collection('system setup data')
              .doc('yzVvopbQMA8vl1QqGmhV')
              .get();
          String defaultImageUrl = systemSetupDoc.get('image_url');

          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user!.uid)
              .set({
            'username': userName,
            'email': userEmail,
            'uid': authResult.user!.uid,
            'image_url': defaultImageUrl,
          });
        }

        final currentUser = FirebaseAuth.instance.currentUser;
        final userProgressRef = FirebaseFirestore.instance
            .collection('userProgress')
            .doc(currentUser!.uid);
        await userProgressRef.set({
          'totalScore': 0,
          'Mocktesttaken': 0,
          'quickTestTaken': 0,
          'mockAverageScore': 0,
          'quickAveragescore': 0,
          'practice': 0,
          'accuracy': 0,
        });

        final snapshot = await FirebaseFirestore.instance
            .collection('system setup data')
            .doc('TestName')
            .get();
        final testFlag = List<String>.from(snapshot.data()!['TestFlag'] ?? []);
        final mockFlag =
            List<String>.from(snapshot.data()!['MockTestFlag'] ?? []);
        for (String flag in testFlag) {
          await userProgressRef.update({flag: false});
          print("flagName ${flag}");
        }
        for (String flag in mockFlag) {
          await userProgressRef.update({flag: false});
          print("flagName ${flag}");
        }
      }

      setState(() {
        isLoading = false;
      });

      // Navigate to home page
      Navigator.of(context).pushReplacementNamed('/homePage');
    } on FirebaseAuthException catch (err) {
      var message = 'An error occurred';

      if (err.message != null) {
        message = err.message.toString();
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );

      setState(() {
        isLoading = false;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: flagSignin
            ? Center(
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.black26),
                ),
              )
            : Center(
                child: Text(
                  'Signup',
                  style: TextStyle(color: Colors.black26),
                ),
              ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 300,
            height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!flagSignin) UserImagePicker(userPickImage),
                if (flagSignin)
                  Center(
                    child: Container(
                        height: 130,
                        width: 130,
                        child: Image.asset('assets/life_in_the_uk_Logo.png')),
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
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'Please Enter valid Email';
                      }
                      return null;
                    },
                    onChanged: (value) => userEmail = value,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                if (!flagSignin)
                  Container(
                    margin: EdgeInsets.all(5),
                    child: TextFormField(
                      key: ValueKey('username'),
                      decoration: InputDecoration(
                        label: Text('Username'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.account_balance_rounded),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length <= 4) {
                          return 'Username is Invalid';
                        }
                        return null;
                      },
                      onChanged: (value) => userName = value,
                    ),
                  ),
                if (!sentEmail)
                  Container(
                    margin: EdgeInsets.all(5),
                    child: TextFormField(
                      key: ValueKey('password'),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.key_outlined),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              obscuretext = !obscuretext;
                            });
                          },
                          child: obscuretext
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 7) {
                          return 'Password must be at least 7 characters';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        password = value;
                        userPass = password;
                      },
                      obscureText: obscuretext,
                    ),
                  ),
                if (!flagSignin)
                  Container(
                    margin: EdgeInsets.all(5),
                    child: TextFormField(
                      key: ValueKey('Confirm Password'),
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.key_outlined),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              confirmobscuretext = !confirmobscuretext;
                            });
                          },
                          child: confirmobscuretext
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off),
                        ),
                      ),
                      validator: (value) {
                        if (value != password) {
                          return 'Confirm password should be same as password';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        confirmpassword = value;
                        if (password == confirmpassword) userPass = password;
                      },
                      obscureText: confirmobscuretext,
                    ),
                  ),
                if (isLoading)
                  SingleChildScrollView(
                    child: Center(
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: Lottie.asset('assets/animation_lktxrmr3.json'),
                      ),
                    ),
                  ),
                if (flagSignin && !isLoading)
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        forgetPassword();
                      },
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(color: Colors.blue, fontSize: 15),
                      ),
                    ),
                  ),
                if (!isLoading)
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () {
                        submitUserData(
                            userEmail, userName, userPass, flagSignin, context);
                      },
                      child: Text(
                        flagSignin ? 'Sign In' : 'Sign Up',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                if (!isLoading)
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        !flagSignin
                            ? Text('You are a member?')
                            : Text('Not a member?'),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                flagSignin = !flagSignin;
                                submitUserData(userEmail, userName, userPass,
                                    flagSignin, context);
                              });
                            },
                            child: Text(
                              !flagSignin ? 'Log In' : 'Register now',
                              style: TextStyle(
                                color: Color.fromARGB(197, 3, 82, 193),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
