import 'dart:io' show Platform;
import 'package:farmtab_ai_frontend/site/SiteList.dart';
import 'package:farmtab_ai_frontend/site/favourite_site.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'package:farmtab_ai_frontend/widget/tab_button.dart';
import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/homepage/home_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import '../login_register/welcome_screen.dart';
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
  Widget currentTab = const SiteList();

  bool isLoading = true;
  bool hasOrganization = true;
  String username = "User";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchUserProfile();
    });
  }

  Future<void> fetchUserProfile() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userData = await authProvider.getUserProfile(context);

      setState(() {
        username = userData['username'] ?? "User";
        hasOrganization = userData['organization_id'] != null;
        isLoading = false;

        // Set default tab based on organization
        if (hasOrganization) {
          selectTab = 1;
          currentTab = const SiteList();
        } else {
          currentTab = _noOrganizationPage(context); // Fallback message page
        }
      });
    } catch (e) {
      print('Failed to load user profile: $e');
      setState(() {
        isLoading = false;
        hasOrganization = false;
        currentTab = _noOrganizationPage(context);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(TColor.primaryColor1),
        ),
      )
          : PageStorage(bucket: pageBucket, child: currentTab),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: hasOrganization
      // ?SizedBox(
      //   width: 65,
      //   height: 65,
      //   child: InkWell(
      //     onTap: () {
      //       Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => ChatPage(),
      //       ),
      //     );},
      //     child: Container(
      //       width: 45,
      //       height: 45,
      //       decoration: BoxDecoration(
      //           gradient: LinearGradient(
      //             colors: TColor.primaryG,
      //           ),
      //           borderRadius: BorderRadius.circular(35),
      //           boxShadow: const [
      //             BoxShadow(
      //               color: Colors.black12,
      //               blurRadius: 2,)
      //           ]),
      //       child: Icon(Icons.chat_outlined,color: TColor.white, size: 26, ),
      //     ),
      //   ),
      // )
      //       : null,
      bottomNavigationBar: hasOrganization
     ?BottomAppBar(
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
                // const  SizedBox(width: 10,),
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
          ))
          : null,
    );
  }
}

Widget _noOrganizationPage(BuildContext context) {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);

  return Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: TColor.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: TColor.primaryColor1.withOpacity(0.1),
              blurRadius: 40,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.corporate_fare_outlined,
              size: 80,
              color: TColor.primaryColor1,
            ),
            const SizedBox(height: 16),
            Text(
              "No Organization Access",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: TColor.primaryColor1,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Your account is not assigned to any organization. "
                  "\nPlease contact the administrator for access.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: TColor.secondaryColor1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "kelven.farmtabai@gmail.com",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: TColor.primaryColor1.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await authProvider.logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                      (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.primaryColor1,
                foregroundColor: TColor.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
              ),
              child: const Text(
                "Log Out",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}