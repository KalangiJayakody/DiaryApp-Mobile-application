import 'package:diary_plus/components/navigation_bar.dart';
import 'package:diary_plus/pages/spalsh_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});
// use to manage the navigation when already login
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const OnboardScreen();
            }
            return const NavBar();
          }),
    );
  }
}
