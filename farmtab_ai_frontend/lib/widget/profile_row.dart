import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';

class ProfileRow extends StatelessWidget {
  final String icon;
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
            Image.asset(icon,
                height: 24, width: 24, fit: BoxFit.contain),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: TColor.primaryColor1,
                  fontSize: 14,
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