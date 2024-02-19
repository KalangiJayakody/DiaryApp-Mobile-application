
import 'package:diary_plus/components/navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  signInWithGoogle(context) async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    if (gUser != null) {
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      if (credential.idToken != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (
              context,
            ) =>
                    const NavBar()));
      }
    }
  }
}
