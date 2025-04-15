import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme.dart';
import 'page/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo_splash.png',
              width: 233,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void movingToNextScreen() {
    Timer(
      Duration(seconds: 3),
      () {
        Get.off(() => HomeScreen());
      },
    );
  }

  @override
  void initState() {
    super.initState();
    movingToNextScreen();
  }
}
