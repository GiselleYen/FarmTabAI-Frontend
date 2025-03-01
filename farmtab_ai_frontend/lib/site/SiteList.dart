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
  int unreadNotifications = 3;

  void _showContextMenu(BuildContext context, Map<String, String> site, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                site["title"] ?? "Site Options",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: TColor.primaryColor1,
                  fontFamily: "Poppins",
                ),
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.edit, color: TColor.primaryColor1),
                title: Text(
                  'Edit Site',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: AddFarmModal(
                        initialName: site["title"],
                        initialDescription: site["description"],
                        initialImagePath: site["img"],
                        onSave: (name, description, image) {
                          setState(() {
                            siteData[index] = {
                              "title": name,
                              "description": description,
                              "img": image?.path ?? site["img"]!,
                            };
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text(
                  'Delete Site',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text(
                          'Delete Site',
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          'Are you sure you want to delete this site?',
                          style: TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: TColor.primaryColor1,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.red,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                siteData.removeAt(index);
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

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
                      SizedBox(width: 6,),
                      Text(
                        "Your Site",
                        style: TextStyle(
                          color: TColor.primaryColor1,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        icon: Icon(
                          Icons.add,
                          color: TColor.primaryColor1,
                          size: 20,
                        ),
                        label: Text(
                          'Add Site',
                          style: TextStyle(
                            color: TColor.primaryColor1,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Inter",
                          ),
                        ),
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
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 14), // Add some padding
                        ),
                      ),
                      Stack(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NotificationView(),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.notifications_none_sharp,
                              size: 28,
                              color: TColor.primaryColor1,
                            ),
                          ),

                          // Show badge only if there are unread notifications
                          if (unreadNotifications > 0)
                            Positioned(
                              right: 5, // Position on the top-right corner
                              top: 5,
                              child: Container(
                                padding: EdgeInsets.all(5), // Adjust padding for better fit
                                decoration: BoxDecoration(
                                  color: Colors.red, // Badge background color
                                  shape: BoxShape.circle, // Circular shape
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 8, // Minimum size of the badge
                                  minHeight: 8,
                                ),
                                child: Center(
                                  child: Text(
                                    unreadNotifications.toString(), // Display unread count
                                    style: TextStyle(
                                      color: Colors.white, // Text color
                                      fontSize: 12, // Adjust text size
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
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
                          fontSize: 14,
                          color: Colors.grey.withOpacity(0.70),
                          fontFamily: "Poppins",
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.withOpacity(0.85),
                        ),
                        // suffixIcon: Icon(
                        //   Icons.arrow,
                        //   color: TColor.primaryColor1.withOpacity(.9),
                        // ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 10.0), // Add bottom padding
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final site = filteredData[index];
                  return GestureDetector(
                    onLongPress: () => _showContextMenu(context, site, index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                      child: CardHorizontal(
                        title: site["title"] ?? "Unknown Site",
                        description: site["description"] ?? "",
                        img: site["img"] ?? "https://via.placeholder.com/200",
                        tap: () {
                          print("Tapped on ${site["title"]}");
                          // Your existing tap handler
                        },
                        timestamp: DateTime.now(),
                      ),
                    ),
                  );
                },
                childCount: filteredData.length,
              ),
            ),
          ),
        ],
      ),
    );

  }
}


