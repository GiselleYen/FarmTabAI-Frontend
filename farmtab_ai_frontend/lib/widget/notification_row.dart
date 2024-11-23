
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'package:flutter/material.dart';

class NotificationRow extends StatelessWidget {
  final Map nObj;
  const NotificationRow({super.key, required this.nObj});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              nObj["image"].toString(),
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nObj["title"].toString(),
                    style: TextStyle(
                        color: TColor.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  ),
                  Text(
                    nObj["time"].toString(),
                    style: TextStyle(
                      color: TColor.gray,
                      fontSize: 10,
                    ),
                  ),
                ],
              )),
          IconButton(
              onPressed: () {},
              icon: Image.asset(
                "assets/images/sub_menu.png",
                width: 12,
                height: 12,
                fit: BoxFit.contain,
              ))
        ],
      ),
    );
  }
}