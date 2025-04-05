import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';

class CardHorizontal extends StatelessWidget {
  CardHorizontal({
    this.title = "Placeholder Title",
    this.description = "",
    this.img = "https://via.placeholder.com/200",
    this.price = "",
    this.timestamp,
    this.tap = defaultFunc,
    this.farmId,
  });

  final String description;
  final String img;
  final Function tap;
  final String title;
  final String price;
  final DateTime? timestamp;
  final int? farmId;

  static void defaultFunc() {
    print("the function works!");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => tap(),
      child: Container(
        height: 260,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [TColor.primaryColor1.withOpacity(0.1), TColor.primaryColor2.withOpacity(0.1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Image.network(
                  img,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(TColor.primaryColor1),
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: TColor.lightGray,
                      child: Center(
                        child: Icon(Icons.image_not_supported, color: Colors.grey[400], size: 40),
                      ),
                    );
                  },
                ),
              ),
              // Content section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                color: TColor.primaryColor1,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins",
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontFamily: "Inter",
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacer(),
                      if (timestamp != null)
                        Text(
                          '${timestamp!.day}/${timestamp!.month}/${timestamp!.year}',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 12,
                            fontFamily: "Inter",
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms),
    );
  }
}