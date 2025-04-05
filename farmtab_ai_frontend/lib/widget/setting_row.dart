import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';

class SettingRow extends StatelessWidget {
  final IconData iconData;
  final String title;
  final VoidCallback onPressed;

  const SettingRow({
    super.key,
    required this.iconData,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        height: 40,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(colors: TColor.primaryG).createShader(bounds),
              child: Icon(
                iconData,
                size: 20,
                color: Colors.white, // Important for gradient to show properly
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 14,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: TColor.gray),
          ],
        ),
      ),
    );
  }
}