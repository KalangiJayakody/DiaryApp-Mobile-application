import 'package:diary_plus/components/skip.dart';
import 'package:diary_plus/constant.dart';
import 'package:diary_plus/pages/splash_screen_two.dart';
import 'package:flutter/material.dart';

class SpalshScreenOne extends StatelessWidget {
  const SpalshScreenOne({super.key});

  @override
  // Building the guide page one
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              height: 400,
              child: Image.asset('lib/assets/sp1.png'),
            ),
            const SizedBox(
              height: 10,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Track Your Emotions',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 5.0, // Set thickness of the divider
              color: colorExtra, // Set color of the divider
              indent: 10, // Set starting indentation
              endIndent: 10, // Set ending indentation
            ),
            const SizedBox(
              height: 50,
            ),
            FractionallySizedBox(
              widthFactor: 0.5,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SplashScreenTwo()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: btnPurple, // Set the background color
                  foregroundColor: black, // Set the text color
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 15), // Set button padding
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20), // Set border radius
                    // You can also use other shapes like StadiumBorder(), BeveledRectangleBorder(), etc.
                  ),
                  elevation: 5, // Set elevation
                  // Other properties like minimumSize, side, textStyle, shadowColor, etc., can also be applied here
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          ]),
        ),
        floatingActionButton: SizedBox(
          height: 20,
          width: 40,
          child: FloatingActionButton(
            elevation: 0,
            backgroundColor: Colors.white,
            onPressed: () {
              SkipTwo(context);
            },
            child: Text(
              'Skip >',
              style: TextStyle(color: purple),
            ),
          ),
        ),
      ),
    );
  }
}
