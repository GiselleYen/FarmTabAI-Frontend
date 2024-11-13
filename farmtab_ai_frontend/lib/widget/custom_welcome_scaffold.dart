import 'package:flutter/material.dart';

class CustomWelcomeScaffold extends StatelessWidget {
  const CustomWelcomeScaffold({super.key, this.child});
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/welcome_plantpic.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Dark overlay
          Container(
            color: Colors.black.withOpacity(0.15),
          ),
          SafeArea(
            child: child!,
          ),
        ],
      ),
    );
  }
}