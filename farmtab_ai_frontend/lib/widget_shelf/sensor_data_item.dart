import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
enum TrendDirection { increase, decrease, equal }
class SensorDataItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final TrendDirection trend;

  const SensorDataItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    Icon trendIcon;
    switch (trend) {
      case TrendDirection.increase:
        trendIcon = Icon(Icons.arrow_upward, size: 14, color: Colors.green);
        break;
      case TrendDirection.decrease:
        trendIcon = Icon(Icons.arrow_downward, size: 14, color: Colors.red);
        break;
      case TrendDirection.equal:
      default:
        trendIcon = Icon(Icons.horizontal_rule, size: 14, color: Colors.grey);
    }
    return Row(
      children: [
        Icon(icon, size: 20, color: TColor.primaryColor1),
        SizedBox(width: 4),
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
                trendIcon,
              ],
            ),
          ],
        ),
      ],
    );
  }
}