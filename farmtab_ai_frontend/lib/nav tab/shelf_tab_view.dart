import 'dart:io' show Platform;
import 'package:farmtab_ai_frontend/shelf/device_register.dart';
import 'package:farmtab_ai_frontend/shelf/sensor_data_dashboard.dart';
import 'package:farmtab_ai_frontend/assistant/virtual%20assistant.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'package:flutter/material.dart';
import '../models/shelf.dart';
import '../services/user_service.dart';
import '../shelf/range_setting.dart';
import 'chat.dart';

class ShelfTabView extends StatefulWidget {
  final Shelf shelf;

  const ShelfTabView({Key? key, required this.shelf}) : super(key: key);

  @override
  State<ShelfTabView> createState() => _ShelfTabViewState();
}

class _ShelfTabViewState extends State<ShelfTabView> {
  int selectTab = 0;
  final PageStorageBucket pageBucket = PageStorageBucket();
  late Widget currentTab;
  bool isExpanded = false;
  String userRole = '';

  void _toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }
  @override
  void initState() {
    super.initState();
    currentTab = SensorDataDashboard(shelfId: widget.shelf.id, shelfName: widget.shelf.name);
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    try {
      final userService = UserService();
      final userProfile = await userService.getUserProfile();
      setState(() {
        userRole = userProfile['role'] ?? 'user';
      });
    } catch (e) {
      print('Failed to fetch user role: $e');
      setState(() {
        userRole = 'user'; // default fallback
      });
    }
  }

  Widget _buildActionButton(String label, String iconPath, int tabIndex, VoidCallback onPressed) {
    if (!isExpanded) return const SizedBox.shrink();

    return AnimatedSlide(
      duration: const Duration(milliseconds: 200),
      offset: Offset.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: TColor.primaryColor1,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontFamily: "Poppins"),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            heroTag: "fab_$tabIndex",
            mini: true,
            backgroundColor: selectTab == tabIndex ? TColor.primaryColor1 : Colors.grey,
            onPressed: onPressed,
            child: Image.asset(
              iconPath,
              width: 20,
              height: 20,
              color: selectTab == tabIndex ? Colors.white : Colors.white54,
            ),
          ),
        ],
      ),
    );
  }

  void _showRestrictedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return Dialog(
          elevation: 10,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.white.withOpacity(0.9)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: TColor.primaryColor1.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon at the top
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: TColor.primaryColor1.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    color: TColor.primaryColor1,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  "Access Denied",
                  style: TextStyle(
                    color: TColor.primaryColor1,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),

                // Divider
                Container(
                  height: 2,
                  width: 50,
                  decoration: BoxDecoration(
                    color: TColor.primaryColor1.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),

                // Content
                Text(
                  "Restricted to Your Manager",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // Button
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.primaryColor1,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.primaryColor1,
      body: PageStorage(
        bucket: pageBucket,
        child: currentTab,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildActionButton(
            "Sensors",
            "assets/images/sensor.png",
            0,
                () {
              selectTab = 0;
              currentTab = SensorDataDashboard(shelfId: widget.shelf.id, shelfName: widget.shelf.name);
              _toggleExpanded();
              setState(() {});
            },
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            "Setting Range",
            "assets/images/calibrate.png",
            1,
                () {
              if (userRole != 'manager') {
                _showRestrictedDialog();
                return;
              }
              selectTab = 1;
              currentTab = OptimalRangeSettingsPage(shelfId: widget.shelf.id);
              _toggleExpanded();
              setState(() {});
            },
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            "Devices",
            "assets/images/devices.png",
            2,
                () {
              if (userRole != 'manager') {
                _showRestrictedDialog();
                return;
              }
              selectTab = 2;
              currentTab = DeviceRegistrationPage(shelf: widget.shelf);
              _toggleExpanded();
              setState(() {});
            },
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            "Chat",
            "assets/images/chat.png",
            3,
                () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VirtualAssistantPage()),
              );
              _toggleExpanded();
            },
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "fab_main",
            onPressed: _toggleExpanded,
            backgroundColor: TColor.primaryColor1,
            child: AnimatedRotation(
              duration: const Duration(milliseconds: 200),
              turns: isExpanded ? 0.125 : 0, // Rotates 45 degrees
              child: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
