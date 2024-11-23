import 'package:farmtab_ai_frontend/homepage/home_page.dart';
import 'package:farmtab_ai_frontend/nav%20tab/home_tab_view.dart';
import 'package:farmtab_ai_frontend/site/SiteList.dart';
import 'package:farmtab_ai_frontend/site/site.dart';
import 'package:flutter/material.dart';
import 'login_register/onboarding_screen.dart';
import 'login_register/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmTab AI',
      // home: OnboardingScreen(),
      home: HomeTabView(),
      // home: SiteList(),
      debugShowCheckedModeBanner: false,
    );
  }
}