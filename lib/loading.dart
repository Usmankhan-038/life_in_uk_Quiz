import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  // late Animation<double> _animation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Test Prep For Life In Uk'),
      //   backgroundColor: Colors.white,
      // ),
      body: Center(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Image.asset('assets/life_in_the_uk_Logo.png'),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
