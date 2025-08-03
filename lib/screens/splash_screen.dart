import 'package:flutter/material.dart';
import 'dart:async';

import 'package:trafficking_detector/screens/home_screen.dart';
import 'package:trafficking_detector/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => MainScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        body: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          height: 700,
          width: 400,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ));
  }
}
