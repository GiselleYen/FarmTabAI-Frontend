import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import '../homepage/notification_view.dart';
import '../widget/add_farm_modal.dart';
import '../widget/card_horizontal.dart';

class SiteList extends StatefulWidget {
  const SiteList({Key? key}) : super(key: key);

  @override
  State<SiteList> createState() => _SiteListState();
}

class _SiteListState extends State<SiteList> {
  // Sample data for the cards
  final List<Map<String, String>> siteData = [
    {
      "title": "Farm A",
      "description": "A picturesque farm known for its organic produce and sustainable practices.",
      "img": "assets/images/farmA.jpg"
    },
    {
      "title": "Farm B",
      "description": "Nestled in rolling hills, this farm specializes in hydroponic vegetables and herbs.",
      "img": "assets/images/farmB.jpg"
    },
    {
      "title": "Farm C",
      "description": "An innovative farm focused on eco-friendly technologies and farm-to-table freshness.",
      "img": "assets/images/farmC.jpg"
    },
    {
      "title": "Farm D",
      "description": "A picturesque farm known for its organic produce and sustainable practices.",
      "img": "assets/images/farmA.jpg"
    },
    {
      "title": "Farm E",
      "description": "Nestled in rolling hills, this farm specializes in hydroponic vegetables and herbs.",
      "img": "assets/images/farmB.jpg"
    },
    {
      "title": "Farm F",
      "description": "An innovative farm focused on eco-friendly technologies and farm-to-table freshness.",
      "img": "assets/images/farmC.jpg"
    },
  ];

  // Search query state
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // Filtered data based on the search query
    final filteredData = siteData
        .where((site) =>
        site["title"]!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leadingWidth: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: 120,
            title: Padding(
              padding: const EdgeInsets.only(bottom: 12.0), // Add bottom padding
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Your Site",
                        style: TextStyle(
                          color: TColor.primaryColor1,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: AddFarmModal(
                                onSave: (name, description, image) {
                                  // Handle the saved farm data here
                                  print('Farm Name: $name');
                                  print('Description: $description');
                                  print('Image: ${image?.path}');
                                },
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.add,
                          color: TColor.primaryColor1,
                          size: 26,//
                        ),
                      ),
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
                          color: TColor.primaryColor1.withOpacity(0.6),
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                        prefixIcon: Icon(
                          Icons.search,
                          color: TColor.primaryColor1.withOpacity(.8),
                        ),
                        suffixIcon: Icon(
                          Icons.mic,
                          color: TColor.primaryColor1.withOpacity(.9),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: TColor.primaryColor1.withOpacity(.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final site = filteredData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: CardHorizontal(
                    title: site["title"] ?? "Unknown Site",
                    description: site["description"] ?? "",
                    img: site["img"] ?? "https://via.placeholder.com/200",
                    tap: () {
                      print("Tapped on ${site["title"]}");
                      // Navigate to a detailed page or perform an action
                    },
                  ),
                );
              },
              childCount: filteredData.length,
            ),
          ),
        ],
      ),
    );

  }
}


