import 'package:diary_plus/pages/get_started_screen.dart';
import 'package:diary_plus/pages/spalsh_screen_one.dart';
import 'package:diary_plus/pages/splash_screen_three.dart';
import 'package:diary_plus/pages/splash_screen_two.dart';
import 'package:flutter/material.dart';
import 'package:diary_plus/constant.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  int currentIndex = 0;

  List<Widget> list = [
    const GetStartedScreen(),
    const SpalshScreenOne(),
    const SplashScreenTwo(),
    const SplashScreenThree()
  ];

  @override
  //Managing guiding page and get started page
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                itemCount: list.length,
                itemBuilder: (context, index) {
                  list[index];
                  return PageBuilderWidget(
                    list[index],
                    screen: list[index],
                  );
                }),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.230,
              left: MediaQuery.of(context).size.width * 0.44,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  list.length,
                  (index) => buildDot(index: index),
                ),
              ),
            ),
            /* currentIndex < list.length - 1
                ?*/
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            )
          ],
        ),
      ),
    );
  }

// Managing build dot
  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentIndex == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentIndex == index ? purple : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class PageBuilderWidget extends StatelessWidget {
  final Widget screen;
  const PageBuilderWidget(
    Widget list, {
    super.key,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: screen,
    );
  }
}
