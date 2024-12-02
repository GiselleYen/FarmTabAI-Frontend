import 'dart:io';
import 'package:farmtab_ai_frontend/shelf/calibration.dart';
import 'package:farmtab_ai_frontend/shelf/sensor_data.dart';
import 'package:farmtab_ai_frontend/site/SiteList.dart';
import 'package:farmtab_ai_frontend/site/site.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'package:farmtab_ai_frontend/widget_shelf/shelf_tab_button.dart';
import 'package:flutter/material.dart';

import '../profile/profile_view.dart';
import '../shelf/chat.dart';
import '../shelf/devices_mange.dart';

class ShelfTabView extends StatefulWidget {
  const ShelfTabView({super.key});

  @override
  State<ShelfTabView> createState() => _ShelfTabViewState();
}

class _ShelfTabViewState extends State<ShelfTabView> {
  int selectTab = 0;
  final PageStorageBucket pageBucket = PageStorageBucket();
  Widget currentTab = const SensorData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.primaryColor1,
      body: PageStorage(bucket: pageBucket, child: currentTab),
      bottomNavigationBar: BottomAppBar(
          height: Platform.isIOS ? 70 : 65,
          color: Colors.transparent,
          padding: const EdgeInsets.all(0),
          child: Container(
            height: Platform.isIOS ? 70 : 65,
            decoration: BoxDecoration(
                color: TColor.primaryColor1,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, -2))
                ]),//
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ShelfTabButton(
                    icon: "assets/images/sensor.png",
                    tabTitle: "Sensor",
                    isActive: selectTab == 0,
                    onTap: () {
                      selectTab = 0;
                      currentTab = const SensorData();
                      if (mounted) {
                        setState(() {});
                      }
                    }),
                ShelfTabButton(//
                    icon: "assets/images/calibrate.png",
                    tabTitle: "Calibration",
                    isActive: selectTab == 1,
                    onTap: () {
                      selectTab = 1;
                      currentTab = CalibrationPage();
                      if (mounted) {
                        setState(() {});
                      }
                    }),
                // const  SizedBox(width: 40,),
                ShelfTabButton(
                    icon: "assets/images/devices.png",
                    tabTitle: "Devices",
                    isActive: selectTab == 2,
                    onTap: () {
                      selectTab = 2;
                      currentTab = const DevicesMangePage();
                      if (mounted) {
                        setState(() {});
                      }
                    }),
                ShelfTabButton(
                    icon: "assets/images/chat.png",
                    tabTitle: "AI Chat",
                    isActive: selectTab == 3,
                    onTap: () {
                      // selectTab = 3;
                      // currentTab = ChatPage();
                      // if (mounted) {
                      //   setState(() {});//
                      // }
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatPage()),
                      );
                    })
              ],
            ),
          )),
    );
  }
}