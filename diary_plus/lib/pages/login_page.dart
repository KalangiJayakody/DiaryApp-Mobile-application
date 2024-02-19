import 'dart:io';

import 'package:diary_plus/components/navigation_bar.dart';
import 'package:diary_plus/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/created_text_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // sign in function
  signUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Navigator.pop(context);
      if (_focusNode.hasFocus) {
        _focusNode.unfocus();
      }
      emptyMessage();
    } else {
      try {
        UserCredential user =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.pop(context);
        if (_focusNode.hasFocus) {
          _focusNode.unfocus();
        }
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (
              context,
            ) =>
                    const NavBar()));
      } on SocketException {
        Navigator.pop(context);
        lowConnectionMessage("Login Failed");
      } on FirebaseAuthException {
        Navigator.pop(context);
        wrongEmailMessage();
      }
    }
  }

//Invalid credential dialog
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
              "You have used invalid details to login!!! Try Again!!!"),
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
            'Invalid Login',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: purple,
            ),
          ),
          content: const Text("You should provide all the data to login."),
        );
      },
    );
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

// Reset password function
  void _showInputDialog() async {
    String userInput = '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Reset Password',
            style: TextStyle(color: purple),
          ),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'To change your password you have to insert the email address that you have used to register for this app. Then you will receive an email and you can use it to reset you password. Please make sure to use a strong password to protect your account.',
                  textAlign: TextAlign.justify,
                ),
                TextField(
                  onChanged: (value) {
                    userInput = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Type email address',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final FirebaseAuth auth = FirebaseAuth.instance;
                if (userInput != '') {
                  try {
                    await auth.sendPasswordResetEmail(email: userInput);
                    Navigator.pop(context);
                    final snackBar = SnackBar(
                      content: Text(
                        'Successful: Please check your email to reset password',
                        style: TextStyle(color: black),
                      ),
                      backgroundColor: btnPurple,
                      duration: const Duration(seconds: 3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } on SocketException {
                    lowConnectionMessage("Reset Password Failed");
                  }
                }
              },
              child: const Text('OK'),
            ),
          ],
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
                  "Login",
                  style: TextStyle(
                      fontSize: 25, color: purple, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),
                CreatedTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                CreatedTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 25, 10),
                      child: GestureDetector(
                        onTap: _showInputDialog,
                        child: Text("Forgot Password?",
                            style: TextStyle(
                                color: purple, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                FractionallySizedBox(
                  widthFactor: 0.6,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btnPurple, // Background color
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      signUserIn();
                    },
                    child: Text("LOGIN",
                        style: TextStyle(
                            color: black, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: black,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Register Now",
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
