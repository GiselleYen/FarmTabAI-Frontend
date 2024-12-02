import "package:farmtab_ai_frontend/widget/card_small.dart";
import "package:flutter/material.dart";
import "package:farmtab_ai_frontend/theme/color_extension.dart";
import "package:farmtab_ai_frontend/homepage/notification_view.dart";

class ShelfList extends StatefulWidget {
  const ShelfList({super.key});

  @override
  State<ShelfList> createState() => _ShelfListState();
}

class _ShelfListState extends State<ShelfList> {
  final List<Map<String, String>> shelfData = [
    {"title": "Shelf A", "img": "assets/images/shelfA.jpg"},
    {"title": "Shelf B", "img": "assets/images/shelfB.jpg"},
    {"title": "Shelf C", "img": "assets/images/shelfC.jpg"},
  ];

  // Search query state
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filteredData = shelfData
        .where((shelf) =>
        shelf["title"]!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FDFA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leadingWidth: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: 130,
            title: Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context); // This will pop the current screen
                        },
                        icon: Icon(
                          Icons.arrow_back, // Back arrow icon
                          color: TColor.primaryColor1,
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text(
                        "Farm A",
                        style: TextStyle(
                          color: TColor.primaryColor1,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationView(),
                            ),
                          );
                        },
                        icon: Image.asset(
                          "assets/images/notification_active.png",
                          width: 20,
                          height: 20,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Container(
                    width: MediaQuery.of(context).size.width * .9,
                    child: TextFormField(
                      cursorColor: TColor.primaryColor1,
                      decoration: InputDecoration(
                        hintText: 'Enter Plant Name',
                        hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.6),
                        ),
                        border: InputBorder.none, 
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.6), // Light color for the border
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: TColor.primaryColor1, // Color when the field is focused
                            width: 1.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.withOpacity(.6),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4), // Rounded corners for the container
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final rowStartIndex = index * 2;
                if (rowStartIndex >= filteredData.length) {
                  return null;
                }
                final firstShelf = filteredData[rowStartIndex];
                final hasSecondItem = rowStartIndex + 1 < filteredData.length;
                final secondShelf = hasSecondItem ? filteredData[rowStartIndex + 1] : null;

                return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: CardSmall(
                            title: firstShelf["title"] ?? "Unknown Shelf",
                            img: firstShelf["img"] ?? "https://via.placeholder.com/200",
                            tap: () {
                              print("Tapped on ${firstShelf["title"]}");
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: hasSecondItem
                              ? CardSmall(
                            title: secondShelf!["title"] ?? "Unknown Shelf",
                            img: secondShelf["img"] ?? "https://via.placeholder.com/200",
                            tap: () {
                              print("Tapped on ${secondShelf["title"]}");
                            },
                          )
                              : Container(),
                        ),
                      ],
                    ),
                  );
              },
              childCount: (filteredData.length + 1) ~/ 2,
            ),
          )
        ],
      ),
    );
  }
}
