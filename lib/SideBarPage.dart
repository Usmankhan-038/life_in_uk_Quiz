import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Drawer(
      backgroundColor: Colors.white,
      shadowColor: Colors.grey,
      surfaceTintColor: Colors.red,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          void _logout() async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/LoginPage', (Route<dynamic> route) => false);
            const ZoomPageTransitionsBuilder();
          }

          if (!snapshot.hasData) return SizedBox();
          String imageUrl = snapshot.data!.get('image_url');
          String currentUserEmail = snapshot.data!.get('email');
          String currentUserName = snapshot.data!.get('username');
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                accountName: GestureDetector(
                  child: Text(
                    currentUserName,
                    style: TextStyle(color: Colors.white),
                  ),
                  // onTap: () {
                  //   Navigator.of(context).pushNamed('/UserAccount');
                  // },
                ),
                accountEmail: GestureDetector(
                  child: Text(
                    currentUserEmail,
                    style: TextStyle(color: Colors.white),
                  ),
                  // onTap: () {
                  //   Navigator.of(context).pushNamed('/UserAccount');
                  // },
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 40,
                  backgroundImage: NetworkImage(imageUrl),
                ),
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text(
                  'Contact Us',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/contactUs');
                },
              ),
              ListTile(
                leading: Icon(Icons.file_copy),
                title: FittedBox(
                  child: Text(
                    'Term and Condition',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/termandcondition');
                },
              ),
              ListTile(
                  leading: Icon(
                    Icons.delete,
                  ),
                  title: Text(
                    "Delete Account",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  onTap: () {
                    FirebaseAuth.instance.currentUser!.delete();
                    _logout();
                  }),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
                onTap: _logout,
              ),
            ],
          );
        },
      ),
    );
  }
}
