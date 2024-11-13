import 'package:flutter/material.dart';
import 'login_register/onboarding_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmTab AI',
      home: OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}