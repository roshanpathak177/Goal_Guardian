import 'package:flutter/material.dart';
import 'package:goal_guardian/pages/login_page.dart';
import 'package:goal_guardian/pages/register_page_1.dart';

class LogingOrRegister extends StatefulWidget {
  const LogingOrRegister({super.key});

  @override
  State<LogingOrRegister> createState() => _LogingOrRegisterState();
}

class _LogingOrRegisterState extends State<LogingOrRegister> {

  //initially show the login page
  bool showLoginPage = true;

  //toggle btw login and register
  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return LoginPage(onTap: togglePages);
    } else {
      return RegisterPage1(onTap: togglePages);
    }
  }
}