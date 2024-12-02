import 'dart:async';
import 'package:flutter/material.dart';
import 'welcome_screen.dart'; // Import your LoginScreen

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();

    // Start a timer to navigate to the login screen after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            padding: const EdgeInsets.only(left:100,right:100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 700,
                  child: Image.asset(
                      "assets/images/onboarding_screen_plant.png",
                    width: 300,
                    height: 300,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                    'FarmTab AI',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF5D8C3F),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Aclonica',
                    ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
