import 'dart:io' show Platform;
import 'package:farmtab_ai_frontend/shelf/calibration.dart';
import 'package:farmtab_ai_frontend/shelf/device_register.dart';
import 'package:farmtab_ai_frontend/shelf/sensor_data_dashboard.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'package:flutter/material.dart';
import 'chat.dart';
import '../shelf/devices_mange.dart';

class ShelfTabView extends StatefulWidget {
  const ShelfTabView({super.key});
  @override
  State<ShelfTabView> createState() => _ShelfTabViewState();
}

class _ShelfTabViewState extends State<ShelfTabView> {
  int selectTab = 0;
  final PageStorageBucket pageBucket = PageStorageBucket();
  Widget currentTab = const SensorDataDashboard();
  bool isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  Widget _buildActionButton(String label, String iconPath, int tabIndex, VoidCallback onPressed) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isExpanded ? 1.0 : 0.0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 200),
        offset: isExpanded ? Offset.zero : const Offset(0.2, 0),
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
                  style: const TextStyle(color: Colors.white, fontFamily: "Poppins",),
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
      ),
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
              currentTab = const SensorDataDashboard();
              _toggleExpanded();
              setState(() {});
            },
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            "Calibration",
            "assets/images/calibrate.png",
            1,
                () {
              selectTab = 1;
              currentTab = CalibrationPage();
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
              selectTab = 2;
              currentTab = DeviceRegistrationPage();
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
                MaterialPageRoute(builder: (context) => ChatPage()),
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