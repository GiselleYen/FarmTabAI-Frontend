import 'dart:io' show Platform;
import 'package:farmtab_ai_frontend/site/SiteList.dart';
import 'package:farmtab_ai_frontend/site/site.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'package:farmtab_ai_frontend/widget/tab_button.dart';
import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/homepage/home_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../profile/profile_view.dart';
// import '../photo_progress/photo_progress_view.dart';
// import '../profile/profile_view.dart';
// import '../workout_tracker/workout_tracker_view.dart';


class HomeTabView extends StatefulWidget {
  const HomeTabView({super.key});

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  int selectTab = 0;
  final PageStorageBucket pageBucket = PageStorageBucket();
  Widget currentTab = const HomePage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: PageStorage(bucket: pageBucket, child: currentTab),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: SizedBox(
      //   width: 70,
      //   height: 70,
      //   child: InkWell(
      //     onTap: () {},
          // child: Container(
          //   width: 65,
          //   height: 65,
          //   decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         colors: TColor.primaryG,
          //       ),
          //       borderRadius: BorderRadius.circular(35),
          //       boxShadow: const [
          //         BoxShadow(
          //           color: Colors.black12,
          //           blurRadius: 2,)
          //       ]),
          //   child: Icon(Icons.search,color: TColor.white, size: 35, ),
          // ),
      //   ),
      // ),
      bottomNavigationBar: BottomAppBar(
          height: kIsWeb ? 60 : (Platform.isIOS ? 70 : 65),
          color: Colors.transparent,
          padding: const EdgeInsets.all(0),
          child: Container(
            height: kIsWeb ? 60 : (Platform.isIOS ? 70 : 65),
            decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, -2))
                ]),//
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TabButton(
                  // #B0A7A8
                  // #2D5523
                    icon: "assets/images/home_tab.png",
                    selectIcon: "assets/images/home_tab_select.png",
                    isActive: selectTab == 0,
                    onTap: () {
                      selectTab = 0;
                      currentTab = const HomePage();
                      if (mounted) {
                        setState(() {});
                      }
                    }),
                TabButton(//
                    icon: "assets/images/site_tab.png",
                    selectIcon: "assets/images/site_tab_select.png",
                    isActive: selectTab == 1,
                    onTap: () {
                      selectTab = 1;
                       currentTab = SiteList();
                      if (mounted) {
                        setState(() {});
                      }
                    }),
                // const  SizedBox(width: 40,),
                TabButton(
                    icon: "assets/images/favourite_tab.png",
                    selectIcon: "assets/images/favourite_tab_select.png",
                    isActive: selectTab == 2,
                    onTap: () {
                      selectTab = 2;
                       currentTab = const SitePage();
                      if (mounted) {
                        setState(() {});
                      }
                    }),
                TabButton(
                    icon: "assets/images/profile_tab.png",
                    selectIcon: "assets/images/profile_tab_select.png",
                    isActive: selectTab == 3,
                    onTap: () {
                      selectTab = 3;
                      currentTab = const ProfileView();
                      if (mounted) {
                        setState(() {});//
                      }
                    })
              ],
            ),
          )),
    );
  }
}