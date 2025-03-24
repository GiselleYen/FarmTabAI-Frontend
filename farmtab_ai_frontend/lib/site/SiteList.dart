import 'dart:io';
import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'package:image_picker/image_picker.dart';
import '../homepage/notification_view.dart';
import '../models/farm_site.dart';
import '../services/farmSite_service.dart';
import '../shelf/shelf_list.dart';
import '../widget/add_farm_modal.dart';
import '../widget/card_horizontal.dart';

class SiteList extends StatefulWidget {
  const SiteList({Key? key}) : super(key: key);

  @override
  State<SiteList> createState() => _SiteListState();
}

class _SiteListState extends State<SiteList> {
  // API service instance
  final FarmService _apiService = FarmService();

  // Farms list
  List<Farm> farms = [];
  bool isLoading = true;
  String? errorMessage;

  // Search query state
  String searchQuery = "";
  int unreadNotifications = 3;

  @override
  void initState() {
    super.initState();
    _loadFarms();
  }

  Future<void> _loadFarms() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedFarms = await _apiService.getFarms();
      setState(() {
        farms = fetchedFarms;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load farms: $e";
        isLoading = false;
      });
    }
  }

  Future<void> _addFarm(String title, String description, XFile? image) async {
    try {
      File? imageFile = image != null ? File(image.path) : null;
      await _apiService.createFarm(title, description, imageFile);
      await _loadFarms(); // Reload farms
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding farm: $e')),
      );
    }
  }

  Future<void> _updateFarm(int id, String title, String description, XFile? image) async {
    try {
      File? imageFile = image != null ? File(image.path) : null;
      await _apiService.updateFarm(id, title, description, imageFile);
      await _loadFarms(); // Reload farms
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating farm: $e')),
      );
    }
  }

  Future<void> _deleteFarm(int id) async {
    try {
      await _apiService.deleteFarm(id);
      await _loadFarms(); // Reload farms
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting farm: $e')),
      );
    }
  }

  void _showContextMenu(BuildContext context, Farm farm) {
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
                farm.title,
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
                    builder: (context) =>
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: AddFarmModal(
                            initialName: farm.title,
                            initialDescription: farm.description,
                            initialImagePath: farm.imageUrl,
                            onSave: (name, description, image) {
                              _updateFarm(farm.id!, name, description, image);
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
                              _deleteFarm(farm.id!);
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
    // Filtered data based on search query
    final filteredFarms = farms
        .where((farm) => farm.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 6),
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
                        builder: (context) =>
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: AddFarmModal(
                                onSave: (name, description, image) {
                                  _addFarm(name, description, image);
                                },
                              ),
                            ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 14),
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
                      if (unreadNotifications > 0)
                        Positioned(
                          right: 5,
                          top: 5,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                              minWidth: 8,
                              minHeight: 8,
                            ),
                            child: Center(
                              child: Text(
                                unreadNotifications.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
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
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextFormField(
                  cursorColor: TColor.primaryColor1,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter Site Name',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.withOpacity(0.70),
                      fontFamily: "Poppins",
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.withOpacity(0.85),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!, style: TextStyle(color: Colors.red)))
          : filteredFarms.isEmpty
          ? Center(child: Text('No farms found'))
          : RefreshIndicator(
        onRefresh: _loadFarms,
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 10.0),
          itemCount: filteredFarms.length,
          itemBuilder: (context, index) {
            final farm = filteredFarms[index];
            return GestureDetector(
              onLongPress: () => _showContextMenu(context, farm),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 5.0, horizontal: 20.0),
                child: CardHorizontal(
                  title: farm.title,
                  description: farm.description,
                  img: farm.imageUrl.isNotEmpty ? farm.imageUrl : "https://via.placeholder.com/200",
                  farmId: farm.id,
                  tap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShelfList(farmId: farm.id!),
                      ),
                    );
                  },
                  timestamp: farm.createdAt ?? DateTime.now(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}