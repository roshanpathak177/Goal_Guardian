import 'package:flutter/material.dart';
import 'package:goal_guardian/components/button.dart';
import 'package:goal_guardian/components/square_tile.dart';
import 'package:goal_guardian/components/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  
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
            const SizedBox(height: 10),
            // welcome  Message
            const Text('Let\'s create an account for you'),
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

            const SizedBox(height: 10),

            MyTextField(
                controller: confirmPasswordTextController, 
                hintText: 'Confirm Password', 
                obscureText: true),

            const SizedBox(height: 5),

            Text('Forgot Password?',
            style: TextStyle(color: Colors.grey.shade600)),

            const SizedBox(height: 30),

            //Sign in Button
            MyButton(onTap: (){}, text: 'Log In'),

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
                const Text('Already a member?'),
                const SizedBox(width: 4,),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text('Login Now', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),)),
              ],
            )

          ]
          ),
      ),
    );
  }
} 