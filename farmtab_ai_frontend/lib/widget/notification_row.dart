import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'package:flutter/material.dart';

class NotificationRow extends StatelessWidget {
  final Map nObj;
  const NotificationRow({super.key, required this.nObj});

  @override
  Widget build(BuildContext context) {
    final bool isRead = nObj["isRead"] == true;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          // Profile image or alert image
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              nObj["image"].toString(),
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),

          // Message and timestamp
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        nObj["title"].toString(),
                        style: TextStyle(
                          color: TColor.black,
                          fontWeight: isRead ? FontWeight.w400 : FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (!isRead)
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  nObj["time"].toString(),
                  style: TextStyle(
                    color: TColor.gray,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          // Optional sub-menu or action
          // IconButton(
          //   onPressed: () {},
          //   icon: Image.asset(
          //     "assets/images/sub_menu.png",
          //     width: 12,
          //     height: 12,
          //     fit: BoxFit.contain,
          //   ),
          // )
        ],
      ),
    );
  }
}
