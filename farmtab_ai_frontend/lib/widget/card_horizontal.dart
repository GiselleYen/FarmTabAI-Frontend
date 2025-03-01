import 'package:farmtab_ai_frontend/shelf/shelf_list.dart';
import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';

class CardHorizontal extends StatelessWidget {
  CardHorizontal({
    this.title = "Placeholder Title",
    this.description = "",
    this.img = "https://via.placeholder.com/200",
    this.price = "",
    this.timestamp,
    this.tap = defaultFunc,
  });

  final String description;
  final String img;
  final Function tap;
  final String title;
  final String price;
  final DateTime? timestamp;

  static void defaultFunc() {
    print("the function works!");
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShelfList(),
            ),
          );
        },
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 8,
                  offset: Offset(3, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 6.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Container(
                      height: 140,
                      width: double.infinity,
                      child: Image.asset(
                        img,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Content section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Inter",
                                  decoration: TextDecoration.underline,
                                  decorationColor: TColor.primaryColor1,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        // Description
                        Text(
                          description,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 13,
                            fontFamily: "Inter",
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(), // This will push the date to the bottom
                        // Timestamp at bottom
                        if (timestamp != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Text(
                              '${timestamp!.day}/${timestamp!.month}/${timestamp!.year}',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                                fontFamily: "Inter",
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}