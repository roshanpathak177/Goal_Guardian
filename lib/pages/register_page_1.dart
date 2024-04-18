import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goal_guardian/components/alert_box.dart';
import 'package:goal_guardian/components/text_field.dart';
import 'package:goal_guardian/pages/register_page_2.dart';

class RegisterPage1 extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage1({super.key, required this.onTap});

  @override
  State<RegisterPage1> createState() => _RegisterPage1State();
}

class _RegisterPage1State extends State<RegisterPage1> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    confirmPasswordTextController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    if (emailTextController.text.trim() == '' || passwordTextController.text.trim() == '') {
      AlertBox(text: "Enter Required Fields");
    } else if (passwordConfirmed()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextController.text.trim(),
          password: passwordTextController.text.trim(),
        );
        // Navigate to the next page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterPage2(
              email: emailTextController.text.trim(),
              password: passwordTextController.text.trim(),
            ),
          ),
        );
      } on FirebaseAuthException catch (ex) {
        AlertBox(text: ex.code.toString());
      }
    }
  }

  bool passwordConfirmed() {
    if (passwordTextController.text.trim() == confirmPasswordTextController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Container(
              width: 150,
              height: 150,
              child: Image.asset('assets/images/Color logo - no background.png'),
            ),
            const SizedBox(height: 10),
            // welcome message
            const Text('Let\'s create an account for you'),
            const SizedBox(height: 10),
            // email textfield
            MyTextField(
              controller: emailTextController,
              hintText: 'Email',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            // password textfield
            MyTextField(
              controller: passwordTextController,
              hintText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 10),
            // confirm password textfield
            MyTextField(
              controller: confirmPasswordTextController,
              hintText: 'Confirm Password',
              obscureText: true,
            ),
            const SizedBox(height: 25),
            // sign up button
            GestureDetector(
              onTap: signUp,
              child: Container(
                padding: const EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            // go to login page
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already a member?'),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    'Login Now',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}