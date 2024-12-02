import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';

class SensorDataItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isIncreasing; // Add parameter for trend direction

  const SensorDataItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.isIncreasing, // Add to constructor
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: TColor.primaryColor1),
        SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: TColor.primaryColor1,
                  ),
                ),
                SizedBox(width: 2),
                Icon(
                  isIncreasing ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16,
                  color: isIncreasing ? Colors.green : Colors.red,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}