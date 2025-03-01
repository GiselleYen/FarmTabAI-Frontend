import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

class ShelfRow extends StatelessWidget {
  final Map wObj;
  const ShelfRow({super.key, required this.wObj});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        decoration: BoxDecoration(
            color: TColor.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                wObj["image"].toString(),
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wObj["name"].toString(),
                      style: TextStyle(
                          color: TColor.primaryColor1,
                          fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    Text(
                      "pH: ${wObj["pH"].toString()} | EC: ${wObj["EC"].toString()}",
                      style: TextStyle(
                        color: TColor.secondaryColor2,
                        fontSize: 11,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    SimpleAnimationProgressBar(
                      height: 15,
                      width: media.width * 0.5,
                      backgroundColor: Colors.grey.shade100,
                      foregrondColor: Colors.purple,
                      ratio: wObj["progress"] as double? ?? 0.0,
                      direction: Axis.horizontal,
                      curve: Curves.fastLinearToSlowEaseIn,
                      duration: const Duration(seconds: 3),
                      borderRadius: BorderRadius.circular(7.5),
                      gradientColor: LinearGradient(
                          colors: TColor.primaryG,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight
                      ),
                    ),
                  ],
                )
            ),
            IconButton(
              onPressed: () {},
              icon: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: const [
                      Color(0xFF76C893),
                      Color(0xFF2D5523),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: const Icon(
                  Icons.arrow_circle_right_outlined,
                  size: 32,
                  color: Colors.white,  // This color will be replaced by the gradient
                ),
              ),
            )
          ],
        )
    );
  }
}