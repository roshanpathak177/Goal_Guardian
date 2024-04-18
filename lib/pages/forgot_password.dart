import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:goal_guardian/components/text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailTextController = TextEditingController();

  @override
  void dispose() {
    emailTextController.dispose();
    super.dispose();
  }

  Future passworReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailTextController.text.trim());
      // Show a success dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Password reset email sent to ${emailTextController.text.trim()}'),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      // Show an error dialog
      if(e.code == 'user-not-found'){
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('The email address is not registered.'),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          },
        );
      }
      
    } catch (e) {
      // Show a generic error dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('An error occurred. Please try again later.'),
          );
        },
      );
    }
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                // Navigate back to the login page
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back),
            ),
            SizedBox(height: 30),
            
            SizedBox(height: 10),
            Center(
              child: Text('Enter your email to reset your password'),
            ),
            SizedBox(height: 30),
            MyTextField(
              controller: emailTextController,
              hintText: 'Email',
              obscureText: false,
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                passworReset();// Implement the forgot password logic here
              },
              child: Container(
                padding: EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    'Reset Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}