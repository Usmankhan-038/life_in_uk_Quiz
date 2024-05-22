import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  void dispose() {
    // Dispose of the animation controller
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Test Prep For Life In Uk'),
      //   backgroundColor: Colors.white,
      // ),
      body: Center(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: screenHeight * 0.05),
          child: Column(
            children: [
              Image.asset('assets/life_in_the_uk_Logo.png'),
              Text(
                'Test Prep For Life In Uk',
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 150,
              ),
              SizedBox(
                  width: 150,
                  height: 150,
                  child: Lottie.asset('assets/animation_lktz86h4.json'))
            ],
          ),
        ),
      ),
    );
  }
}
