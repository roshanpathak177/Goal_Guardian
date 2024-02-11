import 'dart:async';

import 'package:flutter/material.dart';
import 'package:goal_guardian/main.dart';

class Intro extends StatefulWidget{
  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'Home',),));
     });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Center(
          child: const Text("Goal Guardian", style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          )),
        ),
      ),
      );
  }
}