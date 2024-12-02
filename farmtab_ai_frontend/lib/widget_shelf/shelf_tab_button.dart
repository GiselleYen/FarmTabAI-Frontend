import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'package:flutter/material.dart';

class ShelfTabButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  final bool isActive;
  final String tabTitle;
  const ShelfTabButton(
      {super.key,
        required this.icon,
        required this.isActive,
        required this.onTap,
        required this.tabTitle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Image.asset(icon,
            width: 22, height: 22, fit: BoxFit.fitWidth),
        SizedBox(
          height: isActive ?  8: 8,
        ),
        if (isActive)
          Container(
            child: Text(
              tabTitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
      ]),
    );
  }
}