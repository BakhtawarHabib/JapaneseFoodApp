import 'package:flutter/material.dart';

import 'dart:async';
import 'package:hexcolor/hexcolor.dart';
import 'grocerry_kit/SignIn.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(milliseconds: 4000), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return SignInPage();
      }));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Hexcolor('#0644e3'),
      body: Center(
        child: Container(height: 250,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            // color: product.color,
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                  image: AssetImage("images/splash.png"), fit: BoxFit.fitWidth)),
        ),)
      );
  }
}
