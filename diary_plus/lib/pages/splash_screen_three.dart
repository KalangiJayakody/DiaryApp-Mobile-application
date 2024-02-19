import 'package:diary_plus/constant.dart';
import 'package:diary_plus/login_or_register_page.dart';
import 'package:flutter/material.dart';

class SplashScreenThree extends StatefulWidget {
  const SplashScreenThree({super.key});

  @override
  State<SplashScreenThree> createState() => _SplashScreenThreeState();
}

class _SplashScreenThreeState extends State<SplashScreenThree> {
  @override
  // Building the guide page three
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
                child: Image.asset(
              ('lib/assets/sp3.jpg'),
              height: 400,
            )),
            const SizedBox(
              height: 2,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Embrace Better Days',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Ahead',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 3,
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
                          builder: (context) => const LoginOrRegisterPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: btnPurple, // Set the background color
                  foregroundColor: Colors.black, // Set the text color
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
                  'Get Started',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
