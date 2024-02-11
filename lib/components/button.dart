import 'package:flutter/material.dart';

class MyButton extends StatelessWidget{

  final Function()? onTap;
  final String text;
  MyButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25.0),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(15), 
      ),
      child: Center(child: Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 18))),
      );
  }

}