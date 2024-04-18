import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goal_guardian/components/alert_box.dart';
import 'package:goal_guardian/components/text_field.dart';
import 'package:goal_guardian/pages/main_page.dart';

class RegisterPage2 extends StatefulWidget {
  final String email;
  final String password;

  const RegisterPage2({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<RegisterPage2> createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {
  final nameTextController = TextEditingController();
  final genderTextController = TextEditingController();
  final locationTextController = TextEditingController();

  @override
  void dispose() {
    nameTextController.dispose();
    genderTextController.dispose();
    locationTextController.dispose();
    super.dispose();
  }

  Future<void> createAccount() async {
    if (nameTextController.text.trim() == '' || genderTextController.text.trim() == '' || locationTextController.text.trim() == '') {
      AlertBox(text: "Enter Required Fields");
    } else {
      try {
        // Get the current user
        User? user = FirebaseAuth.instance.currentUser;

        // Create a new document in the 'users' collection with the user's data
        await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
          'email': widget.email,
          'name': nameTextController.text.trim(),
          'gender': genderTextController.text.trim(),
          'location': locationTextController.text.trim(),
        });

        // Navigate to the main page or perform any other necessary actions
        // Navigate to the main page
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
          (route) => false,
        );
      } on FirebaseException catch (ex) {
        AlertBox(text: ex.code.toString());
      }
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
            const Text('Let\'s complete your registration'),
            const SizedBox(height: 10),
            // name textfield
            MyTextField(
              controller: nameTextController,
              hintText: 'Name',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            // gender textfield
            MyTextField(
              controller: genderTextController,
              hintText: 'Gender',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            // location textfield
            MyTextField(
              controller: locationTextController,
              hintText: 'Location',
              obscureText: false,
            ),
            const SizedBox(height: 25),
            // create account button
            GestureDetector(
              onTap: createAccount,
              child: Container(
                padding: const EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Text(
                    'Create Account',
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