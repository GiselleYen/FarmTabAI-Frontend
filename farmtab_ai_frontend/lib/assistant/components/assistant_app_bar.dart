import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AssistantAppBar extends StatelessWidget {
  const AssistantAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // Fixed height for the app bar
      decoration: BoxDecoration(
        color: TColor.primaryColor1,
        boxShadow: [
          BoxShadow(
            color: TColor.primaryColor1.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: Colors.white),
              ),
              Expanded(
                child: Text(
                  "FarmTab AI Assistant",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins",
                    shadows: [Shadow(color: Colors.black.withOpacity(0.2), blurRadius: 2, offset: Offset(0, 1))],
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 300.ms),
              ),
              SizedBox(width: 48), // Symmetry with back button
            ],
          ),
        ),
      ),
    );
  }
}