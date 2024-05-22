import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserAccount extends StatefulWidget {
  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  final currentUser = FirebaseAuth.instance.currentUser;
  File? userImage;
  var authResult;
  var userName;
  var userEmail;

  void pickImage() async {
    final pickedUserImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxHeight: 200,
      maxWidth: 200,
    );
    if (pickedUserImage != null) {
      setState(() {
        userImage = File(pickedUserImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Prevents overflow when keyboard is opened
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return SizedBox();
              String imageUrl = snapshot.data!.get('image_url');
              String currentUserEmail = snapshot.data!.get('email');
              String currentUserName = snapshot.data!.get('username');
              double screenHeight = MediaQuery.of(context).size.height;
              return Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        top: 10,
                        left: 20,
                        bottom: 10,
                        right: 20,
                      ),
                      width: double.infinity,
                      height: screenHeight * 0.5,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Positioned(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Positioned(
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: screenHeight * 0.03, left: 0),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed('/homePage');
                                  },
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                top: screenHeight * 0.27,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.camera_alt, size: 30),
                                    ),
                                    onTap: () async {
                                      pickImage();
                                      if (userImage != null) {
                                        final ref = FirebaseStorage.instance
                                            .ref()
                                            .child('User_Image')
                                            .child(currentUser!.uid + '.jpg');
                                        await ref.putFile(userImage!);
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(currentUser!.uid)
                                            .update({
                                          'image_url':
                                              await ref.getDownloadURL()
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Account',
                            style: TextStyle(color: Colors.blue, fontSize: 18),
                          ),
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentUserName,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                  Text(
                                    'Tap to change username',
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
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
                                    padding: EdgeInsets.only(top: 15),
                                    height: screenHeight * 0.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.all(5),
                                            child: TextFormField(
                                              key: ValueKey('username'),
                                              decoration: InputDecoration(
                                                label: Text('Change username'),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                prefixIcon: Icon(Icons
                                                    .account_balance_rounded),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty ||
                                                    value.length <= 4) {
                                                  return 'Username is Invalid';
                                                }
                                                return null;
                                              },
                                              onChanged: (value) =>
                                                  userName = value,
                                            ),
                                          ),
                                          Container(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                              ),
                                              child: Text(
                                                'Update',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () async {
                                                authResult =
                                                    await FirebaseAuth.instance;
                                                await FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(authResult
                                                        .currentUser!.uid)
                                                    .update(
                                                        {'username': userName});
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentUserEmail,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                  Text(
                                    'Tap to change email',
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
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
                                    padding: EdgeInsets.only(top: 15),
                                    height: screenHeight * 0.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.all(5),
                                            child: TextFormField(
                                              key: ValueKey('Email'),
                                              decoration: InputDecoration(
                                                label: Text('Change email'),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                prefixIcon: Icon(Icons.email),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    !value.contains('@')) {
                                                  return 'Invalid email';
                                                }
                                                return null;
                                              },
                                              onChanged: (value) =>
                                                  userEmail = value,
                                            ),
                                          ),
                                          Container(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                              ),
                                              child: Text(
                                                'Update',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () async {
                                                authResult =
                                                    await FirebaseAuth.instance;
                                                await FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(authResult
                                                        .currentUser!.uid)
                                                    .update(
                                                        {'email': userEmail});
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
