import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goal_guardian/components/square_tile.dart';
import 'package:goal_guardian/components/text_field.dart';

class LoginPage extends StatefulWidget{
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
  }

class _LoginPageState extends State<LoginPage>{

  //text editing controller
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  Future signIn() async{
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text.trim(),
        password: passwordTextController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print('Error: $e');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  

  //for better memory management
  @override
  void dispose(){
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Container(
              width: 150,
              height: 150,
              child: Image.asset('assets/images/Color logo - no background.png')),
            const SizedBox(height: 30),
            // welcome  Message
            const Text('Start your Accountability Journey'),
            const SizedBox(height: 10),
            //email textfield
            MyTextField(
                controller: emailTextController, 
                hintText: 'Email', 
                obscureText: false),
              
            const SizedBox(height: 10),

            MyTextField(
                controller: passwordTextController, 
                hintText: 'Password', 
                obscureText: true),

            const SizedBox(height: 5),

            Text('Forgot Password?',
            style: TextStyle(color: Colors.grey.shade600)),

            const SizedBox(height: 30),

            //Sign in Button
            GestureDetector(
              onTap: signIn,
              child: Container(
                padding: EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(15), 
                  ),
                child: const Center(
                  child: Text('Sign in',
                  style: TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.w400, 
                    fontSize: 18)
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 25),

            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // google + apple sign in buttons
              const SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    SquareTile(imagePath: 'assets/images/google.png'),
                
                    SizedBox(width: 25),
                
                    // apple button
                    SquareTile(imagePath: 'assets/images/apple.png')
                  ],
                ),
              ),
        
            //Go to register page
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Not a member?'),
                const SizedBox(width: 4,),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text('Register Now', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),)),
              ],
            )

          ]
          ),
      ),
    );
  }

}