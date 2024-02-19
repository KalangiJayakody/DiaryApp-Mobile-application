import 'dart:io';

import 'package:diary_plus/components/created_text_field.dart';
import 'package:diary_plus/components/navigation_bar.dart';
import 'package:diary_plus/constant.dart';
import 'package:diary_plus/models/user.dart';
import 'package:diary_plus/service/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterPage> {
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

//sign up function
  signUserUp() async {
    if (_userNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      emptyMessage();
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      try {
        if (_passwordController.text == _confirmPasswordController.text) {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
          final FirestoreService fireStoreService = FirestoreService();
          AppUser newUser = AppUser(
              userName: _userNameController.text,
              emailAddress: _emailController.text);
          fireStoreService.addUser(newUser);
          if (_focusNode.hasFocus) {
            _focusNode.unfocus();
          }
          Navigator.pop(context);
          final snackBar = SnackBar(
            content: Text(
              'Successful: You have successfully registered!',
              style: TextStyle(color: black),
            ),
            backgroundColor: btnPurple,
            duration: const Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          Future.delayed(const Duration(seconds: 4), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NavBar(),
              ),
            );
          });
          //AuthPage();
        } else {
          Navigator.pop(context);
          passwordUnmatching();
        }
      } on SocketException {
        Navigator.pop(context);
        lowConnectionMessage('Register Falied');
      } on FirebaseAuthException {
        Navigator.pop(context);
        wrongEmailMessage();
      }
    }
  }

  // Poor connnection dialog
  void lowConnectionMessage(String message) {
    showDialog(
      context: context,
      builder: (contaxt) {
        return AlertDialog(
          title: Text(
            message,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: purple,
            ),
          ),
          content: const Text(
              "Your Intenet connection is poor!!! Try Again with a good connection!!!"),
        );
      },
    );
  }

// empty input message
  void emptyMessage() {
    showDialog(
      context: context,
      builder: (contaxt) {
        return AlertDialog(
          title: Text(
            'Invalid Register',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: purple,
            ),
          ),
          content: const Text("You should provide all the data to register."),
        );
      },
    );
  }

//invalid credentials message
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (contaxt) {
        return AlertDialog(
          title: Text(
            'Invalid Login',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: purple,
            ),
          ),
          content: const Text(
              "You have used invalid details to sign up!!! Try Again!!!"),
        );
      },
    );
  }

//password unmatching message
  void passwordUnmatching() {
    showDialog(
      context: context,
      builder: (contaxt) {
        return AlertDialog(
          title: Text(
            'Passwords Not Matching',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: purple,
            ),
          ),
          content: const Text(
              "Passwords you have enterd are not matching!!! Try Again!!!"),
        );
      },
    );
  }

  @override
  //building the frontend
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Register",
                  style: TextStyle(
                      fontSize: 25, color: purple, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),
                CreatedTextField(
                  controller: _userNameController,
                  hintText: "User Name",
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                CreatedTextField(
                  controller: _emailController,
                  hintText: "Email",
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                CreatedTextField(
                  controller: _passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                CreatedTextField(
                  controller: _confirmPasswordController,
                  hintText: "Confirm Password",
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                FractionallySizedBox(
                  widthFactor: 0.6,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btnPurple, // Background color
                      foregroundColor: black,
                    ),
                    onPressed: () {
                      signUserUp();
                    },
                    child: const Text("REGISTER"),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: black,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Login Now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: purple,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
