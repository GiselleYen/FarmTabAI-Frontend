import 'package:farmtab_ai_frontend/nav%20tab/shelf_tab_view.dart';
import 'package:flutter/material.dart';
import "package:farmtab_ai_frontend/theme/color_extension.dart";

import '../site/site.dart';

class CardSmall extends StatelessWidget {
  CardSmall({
    this.title = "Placeholder Title",
    this.cta = "View details",
    this.img = "https://via.placeholder.com/200",
    this.tap = defaultFunc,
  });

  final String cta;
  final String img;
  final Function tap;
  final String title;

  static void defaultFunc() {
    print("the function works!");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 225,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShelfTabView(),
            ),
          );
        },
        child: Card(
          color: Colors.white,
          elevation: 0.4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6.0),
                      topRight: Radius.circular(6.0),
                    ),
                    image: DecorationImage(
                      image: AssetImage(img),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 15.0,
                    left: 8.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: TColor.primaryColor1,
                          fontSize: 13,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          cta,
                          style: TextStyle(
                            color: TColor.primaryColor1,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
