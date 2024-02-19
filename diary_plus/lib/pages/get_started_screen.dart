import 'package:diary_plus/components/skip.dart';
import 'package:diary_plus/constant.dart';
import 'package:diary_plus/login_or_register_page.dart';
import 'package:diary_plus/pages/spalsh_screen_one.dart';
import 'package:flutter/material.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  bool showLoginPage = true;

  void next() {
    const LoginOrRegisterPage();
  }

// Frontend of get started page
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(height: 400, child: Image.asset('lib/assets/gs.jpg')),
            const SizedBox(
              height: 3,
            ),
            Container(
              child: const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' Diary +',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(198, 30, 171, 1)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Your Closest Companion',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            FractionallySizedBox(
              widthFactor: 0.5,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SpalshScreenOne()),
                  );
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
                  'Let\'s Go',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            //ElevatedButton(onPressed: () {}, child: const Text('Next'))
          ]),
        ),
        floatingActionButton: SizedBox(
          height: 20,
          width: 40,
          child: FloatingActionButton(
            elevation: 0,
            backgroundColor: Colors.white,
            onPressed: () {
              SkipOne(context);
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
