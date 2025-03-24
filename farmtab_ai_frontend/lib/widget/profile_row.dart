import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';

class ProfileRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;
  const ProfileRow({super.key, required this.icon, required this.title, required this.onPressed });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: TColor.primaryG, // Define gradient colors
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: Icon(
                icon,
                size: 26,
                color: Colors.white, // Must set color to white to apply the gradient
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: TColor.primaryColor1,
                  fontSize: 16,
                  fontFamily: "Poppins",
                ),
              ),
            ),
            Image.asset("assets/images/p_next.png",
                height: 14, width: 14, fit: BoxFit.contain)
          ],
        ),
      ),
    );
  }
}