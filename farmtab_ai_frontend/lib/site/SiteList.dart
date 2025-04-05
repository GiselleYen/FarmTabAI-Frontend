import 'dart:io';
import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../homepage/notification_view.dart';
import '../models/farm_site.dart';
import '../providers/auth_provider.dart';
import '../services/farmSite_service.dart';
import '../services/user_service.dart';
import '../shelf/shelf_list.dart';
import '../widget/add_farm_modal.dart';
import '../widget/card_horizontal.dart';

class SiteList extends StatefulWidget {
  const SiteList({Key? key}) : super(key: key);

  @override
  State<SiteList> createState() => _SiteListState();
}

class _SiteListState extends State<SiteList> {
  final FarmService _apiService = FarmService();
  List<Farm> farms = [];
  bool isLoading = true;
  String? errorMessage;
  String searchQuery = "";
  int unreadNotifications = 0;
  String userRole = '';
  int organizationID = 0;
  int userID = 0;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    _fetchUserRole();
    _loadFarms();
  }

  Future<void> fetchUserProfile() async {
    setState(() => isLoading = true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userData = await authProvider.getUserProfile(context);
      setState(() {
        organizationID = userData['organization_id'];
        userID = userData['user_id'];
      });
      final userService = UserService();
      int count = await userService.getUnreadNotificationCount(userID, organizationID);
      setState(() => unreadNotifications = count);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _fetchUserRole() async {
    try {
      final userService = UserService();
      final userProfile = await userService.getUserProfile();
      setState(() => userRole = userProfile['role'] ?? 'user');
    } catch (e) {
      print('Failed to fetch user role: $e');
      setState(() => userRole = 'user');
    }
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
      await _loadFarms();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding farm: $e')));
    }
  }

  Future<void> _updateFarm(int id, String title, String description, XFile? image) async {
    try {
      File? imageFile = image != null ? File(image.path) : null;
      await _apiService.updateFarm(id, title, description, imageFile);
      await _loadFarms();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating farm: $e')));
    }
  }

  Future<void> _deleteFarm(int id) async {
    try {
      await _apiService.deleteFarm(id);
      await _loadFarms();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting farm: $e')));
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
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 5)),
            ],
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
                  color: TColor.lightGray,
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
                title: Text('Edit Site', style: TextStyle(fontFamily: "Inter", fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                title: Text('Delete Site', style: TextStyle(fontFamily: "Inter", fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        title: Text('Delete Site', style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold)),
                        content: Text('Are you sure you want to delete this site?', style: TextStyle(fontFamily: "Inter")),
                        actions: [
                          TextButton(
                            child: Text('Cancel', style: TextStyle(color: TColor.primaryColor1, fontFamily: "Inter", fontWeight: FontWeight.w600)),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: Text('Delete', style: TextStyle(color: Colors.red, fontFamily: "Inter", fontWeight: FontWeight.w600)),
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
    final filteredFarms = farms.where((farm) => farm.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: TColor.backgroundColor1,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            floating: false,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [TColor.primaryColor1.withOpacity(0.8), TColor.primaryColor2.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: TColor.primaryColor1.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Your Sites",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                                shadows: [Shadow(color: Colors.black.withOpacity(0.2), blurRadius: 2, offset: Offset(0, 1))],
                              ),
                            ).animate().fadeIn(duration: 300.ms),
                            Row(
                              children: [
                                if (userRole == 'manager')
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => Padding(
                                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                          child: AddFarmModal(
                                            onSave: (name, description, image) {
                                              _addFarm(name, description, image);
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: TColor.primaryColor1,
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    ),
                                    icon: Icon(Icons.add, size: 20),
                                    label: Text("Add Site", style: TextStyle(fontFamily: "Inter", fontSize: 14, fontWeight: FontWeight.w600)),
                                  ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
                                SizedBox(width: 10),
                                Stack(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationView(organizationID: organizationID, userID: userID))).then((_) => fetchUserProfile());
                                      },
                                      icon: Icon(Icons.notifications_none_sharp, size: 28, color: Colors.white),
                                    ),
                                    if (unreadNotifications > 0)
                                      Positioned(
                                        right: 5,
                                        top: 5,
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                          constraints: BoxConstraints(minWidth: 8, minHeight: 8),
                                          child: Center(
                                            child: Text(
                                              unreadNotifications.toString(),
                                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextFormField(
                            cursorColor: TColor.primaryColor1,
                            onChanged: (value) => setState(() => searchQuery = value),
                            decoration: InputDecoration(
                              hintText: 'Search Sites',
                              hintStyle: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.7), fontFamily: "Inter"),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              prefixIcon: Icon(Icons.search, color: TColor.primaryColor1),
                            ),
                          ),
                        ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: isLoading
                  ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(TColor.primaryColor1)))
                  : errorMessage != null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  SizedBox(height: 16),
                  Text(errorMessage!, style: TextStyle(color: Colors.red, fontFamily: "Inter", fontSize: 16), textAlign: TextAlign.center),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _loadFarms,
                    style: ElevatedButton.styleFrom(backgroundColor: TColor.primaryColor1, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                    child: Text("Try Again", style: TextStyle(color: Colors.white, fontFamily: "Inter", fontWeight: FontWeight.w600)),
                  ),
                ],
              ).animate().fadeIn(duration: 300.ms)
                  : filteredFarms.isEmpty
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: TColor.primaryG, begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.location_city, size: 40, color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    searchQuery.isEmpty ? "No Farm Sites Available" : "No Sites Match Your Search",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87, fontFamily: "Poppins"),
                  ),
                  SizedBox(height: 8),
                  Text(
                    searchQuery.isEmpty
                        ? userRole == 'manager'
                        ? "Tap 'Add Site' to create your first farm site"
                        : "Please contact a manager to add farm sites"
                        : "Try a different search term",
                    style: TextStyle(fontSize: 14, color: Colors.black54, fontFamily: "Inter"),
                    textAlign: TextAlign.center,
                  ),
                  if (userRole == 'manager' && searchQuery.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => Padding(
                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: AddFarmModal(onSave: (name, description, image) => _addFarm(name, description, image)),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColor.primaryColor1,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        icon: Icon(Icons.add, color: Colors.white),
                        label: Text("Add New Site", style: TextStyle(color: Colors.white, fontFamily: "Inter", fontWeight: FontWeight.w600)),
                      ),
                    ),
                ],
              ).animate().fadeIn(duration: 300.ms)
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(color: TColor.primaryColor1, borderRadius: BorderRadius.circular(4)),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Farm Sites",
                          style: TextStyle(
                            color: TColor.primaryColor1,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...filteredFarms.map((farm) => GestureDetector(
                    onLongPress: userRole == 'manager' ? () => _showContextMenu(context, farm) : null,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 5)),
                          ],
                        ),
                        child: CardHorizontal(
                          title: farm.title,
                          description: farm.description,
                          img: farm.imageUrl.isNotEmpty ? farm.imageUrl : "https://via.placeholder.com/200",
                          farmId: farm.id,
                          tap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => ShelfList(farmId: farm.id!, farmName: farm.title),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  const begin = Offset(1.0, 0.0); // Start from right
                                  const end = Offset.zero; // End at center
                                  const curve = Curves.easeInOut;

                                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                  var offsetAnimation = animation.drive(tween);

                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          timestamp: farm.createdAt ?? DateTime.now(),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: (filteredFarms.indexOf(farm) * 100).ms)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}