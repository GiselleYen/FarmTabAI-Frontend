import 'dart:io' show Platform;
import 'package:farmtab_ai_frontend/site/SiteList.dart';
import 'package:farmtab_ai_frontend/site/favourite_site.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'package:farmtab_ai_frontend/widget/tab_button.dart';
import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/homepage/home_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';

import '../profile/profile_view.dart';
import '../providers/auth_provider.dart';
import 'chat.dart';

class HomeTabView extends StatefulWidget {
  const HomeTabView({super.key});

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  int selectTab = 0;
  final PageStorageBucket pageBucket = PageStorageBucket();
  Widget currentTab = const HomePage();

  // // In your HomeTabView or any authenticated screen's initState:
  // @override
  // void initState() {
  //   super.initState();
  //   // Check session validity when screen loads
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<AuthProvider>(context, listen: false).validateSession(context);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      resizeToAvoidBottomInset: false,
      body: PageStorage(bucket: pageBucket, child: currentTab),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 65,
        height: 65,
        child: InkWell(
          onTap: () {
            Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(),
            ),
          );},
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: TColor.primaryG,
                ),
                borderRadius: BorderRadius.circular(35),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,)
                ]),
            child: Icon(Icons.chat_outlined,color: TColor.white, size: 26, ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          height: kIsWeb ? 60 : (Platform.isIOS ? 75 : 70),
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
                const  SizedBox(width: 10,),
                TabButton(
                    icon: "assets/images/favourite_tab.png",
                    selectIcon: "assets/images/favourite_tab_select.png",
                    isActive: selectTab == 2,
                    onTap: () {
                      selectTab = 2;
                       currentTab = const FavoriteShelfPage();
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