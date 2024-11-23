import 'package:farmtab_ai_frontend/site/SiteList.dart';
import 'package:farmtab_ai_frontend/site/site.dart';
import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';

class CardHorizontal extends StatelessWidget {
  CardHorizontal(
      {this.title = "Placeholder Title",
        this.description = "",
        this.img = "https://via.placeholder.com/200",
        this.tap = defaultFunc});

  final String description;
  final String img;
  final Function tap;
  final String title;

  static void defaultFunc() {
    print("the function works!");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: GestureDetector(
        onTap: () {
          // Navigate to the plant page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SitePage(), // Replace with your plant page widget
            ),
          );
        },
        child: Card(
          elevation: 0.6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: TColor.primaryG),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0), // Rounded corners
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Shadow color with opacity
                  spreadRadius: 5, // Spread radius (makes the shadow larger)
                  blurRadius: 5, // Blur radius (makes the shadow softer)
                  offset: Offset(1, 2), // Offset in the x and y directions
                ),
              ],
            ),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.13,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0), // Rounded corners
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // Shadow color with opacity
                          spreadRadius: 1, // Spread radius (makes the shadow larger)
                          blurRadius: 10, // Blur radius (makes the shadow softer)
                          offset: Offset(2, 2), // Offset in the x and y directions
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0), // Add padding around the image
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0), // Rounded corners
                        ),
                        child: Image.asset(
                          this.img,
                          fit: BoxFit.cover, // Keeps the image covering its bounds
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5,),
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          description,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 10,
                            fontFamily: 'Inter',
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
