import 'package:diary_plus/pages/spalsh_screen_one.dart';
import 'package:diary_plus/pages/splash_screen_three.dart';
import 'package:diary_plus/pages/splash_screen_two.dart';
import 'package:flutter/material.dart';

// These are the functions used in get started and splash screen pages regarding skip
void SkipOne(BuildContext context) {
  Future.delayed(const Duration(seconds: 1), () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SpalshScreenOne(),
      ),
    );
  });
  Future.delayed(const Duration(seconds: 2), () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SplashScreenTwo(),
      ),
    );
  });
  Future.delayed(const Duration(seconds: 3), () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SplashScreenThree(),
      ),
    );
  });
}

void SkipTwo(BuildContext context) {
  Future.delayed(const Duration(seconds: 1), () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SplashScreenTwo(),
      ),
    );
  });
  Future.delayed(const Duration(seconds: 2), () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SplashScreenThree(),
      ),
    );
  });
}

void SkipThree(BuildContext context) {
  Future.delayed(const Duration(seconds: 1), () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SplashScreenThree(),
      ),
    );
  });
}
