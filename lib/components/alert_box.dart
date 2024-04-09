import 'package:flutter/material.dart';

class AlertBox extends StatelessWidget{

  
  final String text;
  AlertBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25.0), 
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(15), 
      ),
      child: Center(child: Text(text, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18))),
      );
  }

}