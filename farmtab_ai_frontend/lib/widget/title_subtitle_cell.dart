import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';

class TitleSubtitleCell extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const TitleSubtitleCell({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: TColor.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title and subtitle centered vertically
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: TColor.primaryColor1,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: TColor.primaryColor2,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Icon aligned to the right
            Image.asset(
              "assets/images/p_next.png",
              height: 16,
              width: 16,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}