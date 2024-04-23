import 'dart:async';
import 'package:easyred/Pages/AuthUsers/LoginPage.dart';
import 'package:easyred/Pages/AuthUsers/authPage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 1),
      () => Navigator.pushReplacement(context, PageTransition(
        child: LoginPage(), 
        type: PageTransitionType.leftToRight))
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('AF33E1'),
      body: Center(
        child: RichText(
          text: TextSpan(
              text: 'Easy',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: 'Red',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: HexColor('FFD700')))
              ]),
        ),
      ),
    );
  }
}
